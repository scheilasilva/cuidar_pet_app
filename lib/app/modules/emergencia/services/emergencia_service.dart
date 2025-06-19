import 'dart:convert';
import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/models/veterinario_model.dart';
import 'package:http/http.dart' as http;
import 'emergencia_service_interface.dart';

class EmergenciaService implements IEmergenciaService {
  static const String _mapboxToken = 'pk.eyJ1Ijoic2NoZWlsYWFsYmlubyIsImEiOiJjbWMzdXpkaXAwOTZ3Mmtwc3d3Nm8yN2N3In0.jMLKs6A4pJyD13-aPDgq1g';
  static const String _baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  @override
  Future<List<VeterinarioModel>> buscarVeterinariosProximos(double latitude, double longitude, {double raio = 5.0}) async {
    try {
      // Buscar por diferentes termos relacionados a veterinários
      final List<String> termosBusca = [
        'veterinario',
        'clinica veterinaria',
        'hospital veterinario',
        'pet shop',
      ];

      List<VeterinarioModel> todosVeterinarios = [];

      for (String termo in termosBusca) {
        final veterinarios = await _buscarPorTermo(termo, latitude, longitude, raio);
        todosVeterinarios.addAll(veterinarios);
      }

      // Remover duplicatas baseado na proximidade
      final veterinariosUnicos = _removerDuplicatas(todosVeterinarios);

      // Ordenar por distância
      veterinariosUnicos.sort((a, b) => a.distancia.compareTo(b.distancia));

      return veterinariosUnicos.take(20).toList(); // Limitar a 20 resultados
    } catch (e) {
      print('Erro ao buscar veterinários próximos: $e');
      return [];
    }
  }

  @override
  Future<List<VeterinarioModel>> buscarVeterinariosPorTexto(String query, double latitude, double longitude) async {
    try {
      final veterinarios = await _buscarPorTermo('$query veterinario', latitude, longitude, 10.0);
      veterinarios.sort((a, b) => a.distancia.compareTo(b.distancia));
      return veterinarios.take(10).toList();
    } catch (e) {
      print('Erro ao buscar veterinários por texto: $e');
      return [];
    }
  }

  Future<List<VeterinarioModel>> _buscarPorTermo(String termo, double latitude, double longitude, double raio) async {
    final url = Uri.parse(
        '$_baseUrl/$termo.json?'
            'proximity=$longitude,$latitude&'
            'bbox=${longitude - 0.1},${latitude - 0.1},${longitude + 0.1},${latitude + 0.1}&'
            'limit=10&'
            'access_token=$_mapboxToken'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List;

      return features.map((feature) {
        return VeterinarioModel.fromJson(feature, latitude, longitude);
      }).where((vet) => vet.distancia <= raio).toList();
    } else {
      throw Exception('Falha ao buscar veterinários: ${response.statusCode}');
    }
  }

  List<VeterinarioModel> _removerDuplicatas(List<VeterinarioModel> veterinarios) {
    final Map<String, VeterinarioModel> veterinariosUnicos = {};

    for (var vet in veterinarios) {
      final chave = '${vet.latitude.toStringAsFixed(4)}_${vet.longitude.toStringAsFixed(4)}';
      if (!veterinariosUnicos.containsKey(chave) ||
          veterinariosUnicos[chave]!.distancia > vet.distancia) {
        veterinariosUnicos[chave] = vet;
      }
    }

    return veterinariosUnicos.values.toList();
  }
}

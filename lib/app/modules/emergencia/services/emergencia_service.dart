import 'dart:convert';
import 'dart:math' as math;
import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/models/veterinario_model.dart' show VeterinarioModel;
import 'package:http/http.dart' as http;
import 'emergencia_service_interface.dart';

class EmergenciaService implements IEmergenciaService {
  // 🔑 SUA CHAVE DO GOOGLE PLACES API
  static const String GOOGLE_PLACES_API_KEY = "AIzaSyAHqHBVifRc1xxUajCHxPYmck4QEgYeZ3I";

  // 🗺️ Mapbox apenas para visualização do mapa
  static const String MAPBOX_ACCESS_TOKEN = "pk.eyJ1Ijoic2NoZWlsYWFsYmlubyIsImEiOiJjbWMzemJxM3kwYWRxMm9vcHhvZjM2ZWUyIn0.1J1cLbSOVgBm2ACBUFHywg";

  @override
  Future<List<VeterinarioModel>> buscarVeterinariosProximos(double latitude, double longitude, {double raio = 30.0}) async {
    print('🔍 BUSCANDO VETERINÁRIOS COM GOOGLE PLACES API');
    print('📍 Localização: $latitude, $longitude');
    print('📏 Raio: ${raio}km');

    List<VeterinarioModel> veterinarios = [];

    try {
      // 🎯 MÉTODO 1: Nearby Search - busca por tipo veterinary_care
      veterinarios = await _buscarVeterinariosNearby(latitude, longitude, raio);

      if (veterinarios.isNotEmpty) {
        print('✅ Nearby Search encontrou: ${veterinarios.length}');
        return _ordenarPorDistancia(veterinarios);
      }

      // 🎯 MÉTODO 2: Text Search - busca por texto "veterinário"
      veterinarios = await _buscarVeterinariosTexto(latitude, longitude, raio);

      if (veterinarios.isNotEmpty) {
        print('✅ Text Search encontrou: ${veterinarios.length}');
        return _ordenarPorDistancia(veterinarios);
      }

      // 🎯 MÉTODO 3: Busca ampla por estabelecimentos relacionados
      veterinarios = await _buscarEstabelecimentosRelacionados(latitude, longitude, raio);

      if (veterinarios.isNotEmpty) {
        print('✅ Busca ampla encontrou: ${veterinarios.length}');
        return _ordenarPorDistancia(veterinarios);
      }

      print('⚠️ Nenhum veterinário encontrado na região');
      return [];

    } catch (e) {
      print('❌ Erro ao buscar veterinários: $e');
      throw Exception('Erro ao buscar veterinários: $e');
    }
  }

  @override
  Future<List<VeterinarioModel>> buscarVeterinariosPorTexto(String query, double latitude, double longitude) async {
    print('🔍 BUSCANDO POR TEXTO: "$query"');

    if (query.trim().isEmpty) {
      return await buscarVeterinariosProximos(latitude, longitude);
    }

    try {
      final veterinarios = await _buscarTextoEspecifico(query, latitude, longitude);

      if (veterinarios.isNotEmpty) {
        print('✅ Busca por texto encontrou ${veterinarios.length} resultados');
        return _ordenarPorDistancia(veterinarios);
      }

      // Se busca específica não encontrou, fazer busca geral
      return await buscarVeterinariosProximos(latitude, longitude);

    } catch (e) {
      print('❌ Erro na busca por texto: $e');
      return await buscarVeterinariosProximos(latitude, longitude);
    }
  }

  // 🎯 MÉTODO 1: Google Places Nearby Search
  Future<List<VeterinarioModel>> _buscarVeterinariosNearby(double lat, double lng, double raio) async {
    List<VeterinarioModel> veterinarios = [];

    // Converter raio para metros (máximo 50km = 50000m)
    final raioMetros = math.min(raio * 1000, 50000);

    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
              'location=$lat,$lng&'
              'radius=$raioMetros&'
              'type=veterinary_care&'
              'key=$GOOGLE_PLACES_API_KEY'
      );

      print('🔍 Google Nearby Search - veterinary_care');
      print('🌐 URL: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('📡 Status da API: ${data['status']}');

        if (data['status'] == 'OK') {
          final results = data['results'] as List? ?? [];
          print('📍 Nearby Search: ${results.length} resultados encontrados');

          for (var place in results) {
            final vet = await _criarVeterinarioGoogle(place, lat, lng);
            if (vet != null) {
              veterinarios.add(vet);
              print('✅ Adicionado: ${vet.nome} - ${vet.distanciaFormatada}');
            }
          }
        } else {
          print('❌ Google Places erro: ${data['status']}');
          if (data['error_message'] != null) {
            print('❌ Mensagem: ${data['error_message']}');
          }

          if (data['status'] == 'REQUEST_DENIED') {
            throw Exception('Chave do Google Places inválida ou sem permissões');
          }
        }
      } else {
        print('❌ Erro HTTP: ${response.statusCode}');
        print('❌ Response: ${response.body}');
      }

    } catch (e) {
      print('❌ Erro Nearby Search: $e');
      rethrow;
    }

    return veterinarios;
  }

  // 🎯 MÉTODO 2: Google Places Text Search
  Future<List<VeterinarioModel>> _buscarVeterinariosTexto(double lat, double lng, double raio) async {
    List<VeterinarioModel> todosVeterinarios = [];

    final termos = [
      'veterinário near me',
      'clínica veterinária',
      'hospital veterinário',
      'pet shop veterinário',
      'veterinary clinic'
    ];

    for (String termo in termos) {
      try {
        final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?'
                'query=${Uri.encodeComponent(termo)}&'
                'location=$lat,$lng&'
                'radius=${math.min(raio * 1000, 50000)}&'
                'key=$GOOGLE_PLACES_API_KEY'
        );

        print('🔍 Text Search: $termo');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['status'] == 'OK') {
            final results = data['results'] as List? ?? [];
            print('📍 "$termo": ${results.length} resultados');

            for (var place in results) {
              final vet = await _criarVeterinarioGoogle(place, lat, lng);
              if (vet != null && vet.distancia <= raio) {
                todosVeterinarios.add(vet);
              }
            }
          } else {
            print('❌ Text Search erro para "$termo": ${data['status']}');
          }
        }

        // Pausa entre requests para evitar rate limiting
        await Future.delayed(Duration(milliseconds: 1000));

      } catch (e) {
        print('❌ Erro termo "$termo": $e');
      }
    }

    return _removerDuplicatas(todosVeterinarios);
  }

  // 🎯 MÉTODO 3: Busca por estabelecimentos relacionados
  Future<List<VeterinarioModel>> _buscarEstabelecimentosRelacionados(double lat, double lng, double raio) async {
    List<VeterinarioModel> todosVeterinarios = [];

    // Tipos relacionados a pets
    final tipos = ['pet_store', 'establishment'];

    for (String tipo in tipos) {
      try {
        final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
                'location=$lat,$lng&'
                'radius=${math.min(raio * 1000, 50000)}&'
                'type=$tipo&'
                'keyword=veterinario&'
                'key=$GOOGLE_PLACES_API_KEY'
        );

        print('🔍 Busca por tipo: $tipo com keyword veterinario');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['status'] == 'OK') {
            final results = data['results'] as List? ?? [];
            print('📍 Tipo "$tipo": ${results.length} resultados');

            for (var place in results) {
              // Filtrar apenas estabelecimentos que parecem ser veterinários
              final nome = place['name']?.toString().toLowerCase() ?? '';
              if (_isVeterinarioValido(nome)) {
                final vet = await _criarVeterinarioGoogle(place, lat, lng);
                if (vet != null && vet.distancia <= raio) {
                  todosVeterinarios.add(vet);
                }
              }
            }
          }
        }

        await Future.delayed(Duration(milliseconds: 1000));

      } catch (e) {
        print('❌ Erro tipo "$tipo": $e');
      }
    }

    return _removerDuplicatas(todosVeterinarios);
  }

  // 🎯 Busca por texto específico
  Future<List<VeterinarioModel>> _buscarTextoEspecifico(String query, double lat, double lng) async {
    List<VeterinarioModel> veterinarios = [];

    try {
      final queryCompleta = '$query veterinário';

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?'
              'query=${Uri.encodeComponent(queryCompleta)}&'
              'location=$lat,$lng&'
              'radius=30000&'
              'key=$GOOGLE_PLACES_API_KEY'
      );

      print('🔍 Busca específica: $queryCompleta');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final results = data['results'] as List? ?? [];
          print('📍 Busca específica: ${results.length} resultados');

          for (var place in results) {
            final vet = await _criarVeterinarioGoogle(place, lat, lng);
            if (vet != null && vet.distancia <= 30.0) {
              veterinarios.add(vet);
            }
          }
        }
      }

    } catch (e) {
      print('❌ Erro busca específica: $e');
    }

    return veterinarios;
  }

  // 🏥 Criar veterinário com dados do Google Places
  Future<VeterinarioModel?> _criarVeterinarioGoogle(Map<String, dynamic> place, double userLat, double userLng) async {
    try {
      final geometry = place['geometry'];
      if (geometry == null) return null;

      final location = geometry['location'];
      final lat = location['lat'].toDouble();
      final lng = location['lng'].toDouble();

      final distancia = _calcularDistancia(userLat, userLng, lat, lng);

      final nome = place['name'] ?? 'Veterinário';
      final endereco = place['vicinity'] ?? place['formatted_address'] ?? 'Endereço não disponível';
      final placeId = place['place_id'];
      final rating = place['rating']?.toDouble();

      // Buscar detalhes adicionais
      final detalhes = await _buscarDetalhesLugar(placeId);

      print('🏥 Criando veterinário: $nome');

      return VeterinarioModel(
        id: 'google_$placeId',
        nome: nome,
        endereco: endereco,
        latitude: lat,
        longitude: lng,
        telefone: detalhes['telefone'],
        horarioFuncionamento: detalhes['horario'],
        avaliacao: rating,
        emergencia24h: _verificar24h(nome, detalhes['horario']),
        distancia: distancia,
      );

    } catch (e) {
      print('❌ Erro criar veterinário Google: $e');
      return null;
    }
  }

  // 🔍 Buscar detalhes do lugar (telefone, horário, etc.)
  Future<Map<String, String?>> _buscarDetalhesLugar(String? placeId) async {
    if (placeId == null) return {'telefone': null, 'horario': null};

    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?'
              'place_id=$placeId&'
              'fields=formatted_phone_number,opening_hours,website&'
              'key=$GOOGLE_PLACES_API_KEY'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];

          final telefone = result['formatted_phone_number'];
          final openingHours = result['opening_hours'];
          String? horario;

          if (openingHours != null) {
            final weekdayText = openingHours['weekday_text'] as List?;
            if (weekdayText != null && weekdayText.isNotEmpty) {
              // Pegar os primeiros 2 dias para não ficar muito longo
              horario = weekdayText.take(2).join(', ');
            }
          }

          return {
            'telefone': telefone,
            'horario': horario,
          };
        }
      }

    } catch (e) {
      print('❌ Erro buscar detalhes: $e');
    }

    return {'telefone': null, 'horario': null};
  }

  // ✅ Validar se é realmente um veterinário
  bool _isVeterinarioValido(String nome) {
    final nomeL = nome.toLowerCase();

    // Palavras que indicam veterinário
    final palavrasVet = [
      'veterinar', 'vet ', 'pet', 'animal', 'clinica', 'hospital',
      'cão', 'gato', 'cachorro', 'bichos', 'saude animal', 'petshop'
    ];

    // Palavras que devemos evitar
    final palavrasEvitar = [
      'restaurante', 'lanchonete', 'farmacia', 'posto', 'banco',
      'escola', 'igreja', 'mercado', 'shopping', 'hotel', 'motel'
    ];

    // Verificar se contém palavras a evitar
    for (var palavra in palavrasEvitar) {
      if (nomeL.contains(palavra)) return false;
    }

    // Verificar se contém palavras de veterinário
    for (var palavra in palavrasVet) {
      if (nomeL.contains(palavra)) return true;
    }

    return false;
  }

  // 🕒 Verificar se é 24h
  bool _verificar24h(String nome, String? horario) {
    final nomeL = nome.toLowerCase();
    final horarioL = horario?.toLowerCase() ?? '';

    return nomeL.contains('24') ||
        nomeL.contains('emergência') ||
        nomeL.contains('plantão') ||
        horarioL.contains('24') ||
        horarioL.contains('24 hours') ||
        horarioL.contains('sempre aberto') ||
        horarioL.contains('open 24');
  }

  // 📏 Calcular distância entre dois pontos
  double _calcularDistancia(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
                math.sin(dLng / 2) * math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // 🔄 Remover duplicatas
  List<VeterinarioModel> _removerDuplicatas(List<VeterinarioModel> veterinarios) {
    final Map<String, VeterinarioModel> unicos = {};

    for (var vet in veterinarios) {
      final chave = '${vet.nome.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')}_${vet.latitude.toStringAsFixed(4)}';

      if (!unicos.containsKey(chave)) {
        unicos[chave] = vet;
      } else {
        // Se já existe, manter o que tem mais informações
        final existente = unicos[chave]!;
        if (vet.telefone != null && existente.telefone == null) {
          unicos[chave] = vet;
        }
      }
    }

    final removidas = veterinarios.length - unicos.length;
    if (removidas > 0) {
      print('🔄 Removidas $removidas duplicatas');
    }

    return unicos.values.toList();
  }

  // 📊 Ordenar por distância
  List<VeterinarioModel> _ordenarPorDistancia(List<VeterinarioModel> veterinarios) {
    veterinarios.sort((a, b) => a.distancia.compareTo(b.distancia));
    return veterinarios;
  }
}

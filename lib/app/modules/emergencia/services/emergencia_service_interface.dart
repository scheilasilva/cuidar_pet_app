import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/models/veterinario_model.dart';

abstract class IEmergenciaService {
  Future<List<VeterinarioModel>> buscarVeterinariosProximos(double latitude, double longitude, {double raio = 30.0});
  Future<List<VeterinarioModel>> buscarVeterinariosPorTexto(String query, double latitude, double longitude);
}

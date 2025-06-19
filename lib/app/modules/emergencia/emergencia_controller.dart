import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/models/veterinario_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/emergencia_service_interface.dart';

part 'emergencia_controller.g.dart';

class EmergenciaController = _EmergenciaControllerBase with _$EmergenciaController;

abstract class _EmergenciaControllerBase with Store {
  final IEmergenciaService _service;

  @observable
  ObservableList<VeterinarioModel> veterinarios = ObservableList<VeterinarioModel>();

  @observable
  Position? localizacaoAtual;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingLocation = false;

  @observable
  String? errorMessage;

  @observable
  VeterinarioModel? veterinarioSelecionado;

  _EmergenciaControllerBase(this._service);

  @action
  Future<void> inicializar() async {
    await obterLocalizacao();
    if (localizacaoAtual != null) {
      await buscarVeterinariosProximos();
    }
  }

  @action
  Future<void> obterLocalizacao() async {
    try {
      isLoadingLocation = true;
      errorMessage = null;

      // Verificar e solicitar permissões
      final permissaoStatus = await Permission.location.request();
      if (permissaoStatus.isDenied) {
        errorMessage = 'Permissão de localização negada';
        return;
      }

      // Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage = 'Serviço de localização desabilitado';
        return;
      }

      // Obter localização atual
      localizacaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

    } catch (e) {
      errorMessage = 'Erro ao obter localização: $e';
      print('Erro ao obter localização: $e');
    } finally {
      isLoadingLocation = false;
    }
  }

  @action
  Future<void> buscarVeterinariosProximos() async {
    if (localizacaoAtual == null) return;

    try {
      isLoading = true;
      errorMessage = null;

      final resultado = await _service.buscarVeterinariosProximos(
        localizacaoAtual!.latitude,
        localizacaoAtual!.longitude,
      );

      veterinarios.clear();
      veterinarios.addAll(resultado);

    } catch (e) {
      errorMessage = 'Erro ao buscar veterinários: $e';
      print('Erro ao buscar veterinários: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> buscarVeterinariosPorTexto(String query) async {
    if (localizacaoAtual == null || query.trim().isEmpty) return;

    try {
      isLoading = true;
      errorMessage = null;

      final resultado = await _service.buscarVeterinariosPorTexto(
        query,
        localizacaoAtual!.latitude,
        localizacaoAtual!.longitude,
      );

      veterinarios.clear();
      veterinarios.addAll(resultado);

    } catch (e) {
      errorMessage = 'Erro ao buscar veterinários: $e';
      print('Erro ao buscar veterinários: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  void selecionarVeterinario(VeterinarioModel veterinario) {
    veterinarioSelecionado = veterinario;
  }

  @action
  void limparSelecao() {
    veterinarioSelecionado = null;
  }

  @action
  Future<void> recarregarDados() async {
    await obterLocalizacao();
    if (localizacaoAtual != null) {
      await buscarVeterinariosProximos();
    }
  }
}

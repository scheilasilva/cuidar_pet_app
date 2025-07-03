import 'package:cuidar_pet_app/app/modules/consulta/services/consulta_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/consulta/store/consulta_store.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_service.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'consulta_controller.g.dart';

class ConsultaController = _ConsultaControllerBase with _$ConsultaController;

abstract class _ConsultaControllerBase with Store {
  final IConsultaService _service;
  final NotificacoesService _notificacoesService = NotificacoesService();
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  @observable
  ConsultaStore consulta = ConsultaStoreFactory.novo('');

  @observable
  ObservableList<ConsultaStore> consultas = ObservableList<ConsultaStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  String? animalSelecionadoNome; // IGUAL AO ID

  @observable
  bool isLoading = false;

  _ConsultaControllerBase(this._service);

  @computed
  bool get isFormValid {
    final c = consulta;
    return c.titulo.isNotEmpty &&
        c.descricao.isNotEmpty &&
        c.dataConsulta.isNotEmpty &&
        c.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome; // IGUAL AO ID
    consulta = ConsultaStoreFactory.novo(animalId);
    loadConsultasByAnimal(animalId);
  }

  // Carregar consultas do animal selecionado
  @action
  Future<void> loadConsultasByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      consultas.clear();

      for (var consulta in list) {
        consultas.add(ConsultaStoreFactory.fromModel(consulta));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar consulta
  @action
  Future<void> salvarConsulta() async {
    if (animalSelecionadoId == null) return;

    // Gerar ID se não existir
    if (consulta.id.isEmpty) {
      consulta.id = const Uuid().v4();
    }

    consulta.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(consulta.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(consulta);

    await loadConsultasByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova consulta
  @action
  Future<void> criarConsulta(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novaConsulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novaConsulta.id = const Uuid().v4();
    novaConsulta.titulo = titulo;
    novaConsulta.descricao = descricao;
    novaConsulta.dataConsulta = data;
    novaConsulta.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novaConsulta.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novaConsulta.toModel());
    }

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novaConsulta);

    await loadConsultasByAnimal(animalSelecionadoId!);
  }

  // Excluir consulta específica
  @action
  Future<void> excluirConsulta(ConsultaStore consultaParaExcluir) async {
    // Cancelar notificação agendada
    await _notificacoesService.cancelConsultaNotification(consultaParaExcluir.id);

    await _service.delete(consultaParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadConsultasByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      consulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
    }
  }

  // Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(ConsultaStore consulta) async {
    final isEnabled = await _settingsService.isConsultaEnabled();
    if (!isEnabled) return;

    // Usar o nome do animal selecionado - IGUAL AO ID
    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('🏥 Agendando notificação de consulta...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleConsultaNotification(
      consultaId: consulta.id,
      titulo: consulta.titulo,
      descricao: consulta.descricao,
      dataConsulta: consulta.dataConsulta,
      animalNome: animalNome, // USAR A VARIÁVEL DIRETAMENTE
      animalId: consulta.animalId,
    );
  }
}

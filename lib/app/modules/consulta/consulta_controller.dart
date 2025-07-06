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
  String? animalSelecionadoNome;

  @observable
  bool isLoading = false;

  _ConsultaControllerBase(this._service);

  // ✅ Usar a validação do ConsultaStore
  @computed
  bool get isFormValid => consulta.isFormValid;

  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome;
    consulta = ConsultaStoreFactory.novo(animalId);
    loadConsultasByAnimal(animalId);
  }

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

  // ✅ Método principal para salvar consulta (com ou sem imagem)
  @action
  Future<void> salvarConsulta() async {
    if (animalSelecionadoId == null || !isFormValid) {
      print('❌ Não é possível salvar: animalId=${animalSelecionadoId}, isValid=${isFormValid}');
      return;
    }

    try {
      // Gerar ID se não existir
      if (consulta.id.isEmpty) {
        consulta.id = const Uuid().v4();
      }

      consulta.animalId = animalSelecionadoId!;

      print('💾 Salvando consulta:');
      print('  - ID: ${consulta.id}');
      print('  - Título: ${consulta.titulo}');
      print('  - Descrição: ${consulta.descricao}');
      print('  - Data: ${consulta.dataConsulta}');
      print('  - Imagem: ${consulta.imagem ?? "SEM IMAGEM"}');

      // ✅ Salvar sempre usando o método básico (funciona com ou sem imagem)
      await _service.saveOrUpdate(consulta.toModel());

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(consulta);

      await loadConsultasByAnimal(animalSelecionadoId!);
      resetForm();

      print('✅ Consulta salva com sucesso!');
    } catch (e) {
      print('❌ Erro ao salvar consulta: $e');
      rethrow;
    }
  }

  // ✅ Método simplificado para criar consulta (mantém compatibilidade)
  @action
  Future<void> criarConsulta(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    // Atualizar a consulta atual
    consulta.setTitulo(titulo);
    consulta.setDescricao(descricao);
    consulta.setDataConsulta(data);
    consulta.setImagem(imagem);

    // Salvar usando o método principal
    await salvarConsulta();
  }

  // ✅ Método para criar consulta com imagem (mantém compatibilidade)
  @action
  Future<void> criarConsultaComImagem(String titulo, String descricao, String data, String imagePath) async {
    if (animalSelecionadoId == null) return;

    try {
      final novaConsulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
      novaConsulta.id = const Uuid().v4();
      novaConsulta.setTitulo(titulo);
      novaConsulta.setDescricao(descricao);
      novaConsulta.setDataConsulta(data);

      print('🏥 Criando consulta com imagem...');
      print('🐾 Animal: $animalSelecionadoNome');

      await _service.saveOrUpdateWithImage(novaConsulta.toModel(), imagePath);

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(novaConsulta);

      await loadConsultasByAnimal(animalSelecionadoId!);
    } catch (e) {
      print('❌ Erro ao criar consulta com imagem: $e');
      rethrow;
    }
  }

  @action
  Future<void> excluirConsulta(ConsultaStore consultaParaExcluir) async {
    await _notificacoesService.cancelConsultaNotification(consultaParaExcluir.id);
    await _service.delete(consultaParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadConsultasByAnimal(animalSelecionadoId!);
    }
  }

  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      consulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
    }
  }

  Future<void> _scheduleNotificacaoIfEnabled(ConsultaStore consulta) async {
    final isEnabled = await _settingsService.isConsultaEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de consulta desabilitadas');
      return;
    }

    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('🏥 Agendando notificação de consulta...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleConsultaNotification(
      consultaId: consulta.id,
      titulo: consulta.titulo,
      descricao: consulta.descricao,
      dataConsulta: consulta.dataConsulta,
      animalNome: animalNome,
      animalId: consulta.animalId,
    );
  }
}

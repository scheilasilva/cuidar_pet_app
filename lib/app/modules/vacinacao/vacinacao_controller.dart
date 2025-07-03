import 'package:cuidar_pet_app/app/modules/vacinacao/services/vacinacao_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/vacinacao/store/vacinacao_store.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_service.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'vacinacao_controller.g.dart';

class VacinacaoController = _VacinacaoControllerBase with _$VacinacaoController;

abstract class _VacinacaoControllerBase with Store {
  final IVacinacaoService _service;
  final NotificacoesService _notificacoesService = NotificacoesService();
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  @observable
  VacinacaoStore vacinacao = VacinacaoStoreFactory.novo('');

  @observable
  ObservableList<VacinacaoStore> vacinacoes = ObservableList<VacinacaoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  String? animalSelecionadoNome; // IGUAL AO ID - só uma variável simples

  @observable
  bool isLoading = false;

  _VacinacaoControllerBase(this._service);

  @computed
  bool get isFormValid {
    final v = vacinacao;
    return v.titulo.isNotEmpty &&
        v.descricao.isNotEmpty &&
        v.dataVacinacao.isNotEmpty &&
        v.animalId.isNotEmpty;
  }

  // Definir animal selecionado - IGUAL AO ID, mas agora recebe nome também
  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome; // IGUAL AO ID
    vacinacao = VacinacaoStoreFactory.novo(animalId);
    loadVacinacoesByAnimal(animalId);
  }

  // Carregar vacinações do animal selecionado
  @action
  Future<void> loadVacinacoesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      vacinacoes.clear();

      for (var vacinacao in list) {
        vacinacoes.add(VacinacaoStoreFactory.fromModel(vacinacao));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar vacinação
  @action
  Future<void> salvarVacinacao() async {
    if (animalSelecionadoId == null) return;

    // Gerar ID se não existir
    if (vacinacao.id.isEmpty) {
      vacinacao.id = const Uuid().v4();
    }

    vacinacao.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(vacinacao.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(vacinacao);

    await loadVacinacoesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova vacinação
  @action
  Future<void> criarVacinacao(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novaVacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novaVacinacao.id = const Uuid().v4();
    novaVacinacao.titulo = titulo;
    novaVacinacao.descricao = descricao;
    novaVacinacao.dataVacinacao = data;
    novaVacinacao.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novaVacinacao.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novaVacinacao.toModel());
    }

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novaVacinacao);

    await loadVacinacoesByAnimal(animalSelecionadoId!);
  }

  // Marcar vacinação como concluída
  @action
  Future<void> marcarComoConcluida(VacinacaoStore vacinacaoStore, bool concluida) async {
    vacinacaoStore.concluida = concluida;
    await _service.saveOrUpdate(vacinacaoStore.toModel());

    if (animalSelecionadoId != null) {
      await loadVacinacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Excluir vacinação específica
  @action
  Future<void> excluirVacinacao(VacinacaoStore vacinacaoParaExcluir) async {
    // Cancelar notificação agendada
    await _notificacoesService.cancelVacinacaoNotification(vacinacaoParaExcluir.id);

    await _service.delete(vacinacaoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadVacinacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      vacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
    }
  }

  // Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(VacinacaoStore vacinacao) async {
    final isEnabled = await _settingsService.isVacinacaoEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de vacinação desabilitadas');
      return;
    }

    // Usar o nome do animal selecionado - IGUAL AO ID
    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('💉 Agendando notificação de vacinação...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleVacinacaoNotification(
      vacinacaoId: vacinacao.id,
      titulo: vacinacao.titulo,
      descricao: vacinacao.descricao,
      dataVacinacao: vacinacao.dataVacinacao,
      animalNome: animalNome, // USAR A VARIÁVEL DIRETAMENTE
      animalId: vacinacao.animalId,
    );
  }
}

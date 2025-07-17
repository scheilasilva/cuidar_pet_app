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
  String? animalSelecionadoNome;

  @observable
  bool isLoading = false;

  _VacinacaoControllerBase(this._service);

  // ✅ Usar a validação do VacinacaoStore
  @computed
  bool get isFormValid => vacinacao.isFormValid;

  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome;
    vacinacao = VacinacaoStoreFactory.novo(animalId);
    loadVacinacoesByAnimal(animalId);
  }

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

  // ✅ Método principal para salvar vacinação (com ou sem imagem)
  @action
  Future<void> salvarVacinacao() async {
    if (animalSelecionadoId == null || !isFormValid) {
      print('❌ Não é possível salvar: animalId=${animalSelecionadoId}, isValid=${isFormValid}');
      return;
    }

    try {
      // Gerar ID se não existir
      if (vacinacao.id.isEmpty) {
        vacinacao.id = const Uuid().v4();
      }

      vacinacao.animalId = animalSelecionadoId!;

      print('💾 Salvando vacinação:');
      print('  - ID: ${vacinacao.id}');
      print('  - Título: ${vacinacao.titulo}');
      print('  - Descrição: ${vacinacao.descricao}');
      print('  - Data: ${vacinacao.dataVacinacao}');
      print('  - Imagem: ${vacinacao.imagem ?? "SEM IMAGEM"}');
      print('  - Concluída: ${vacinacao.concluida}');

      // ✅ Salvar sempre usando o método básico (funciona com ou sem imagem)
      await _service.saveOrUpdate(vacinacao.toModel());

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(vacinacao);

      await loadVacinacoesByAnimal(animalSelecionadoId!);
      resetForm();

      print('✅ Vacinação salva com sucesso!');
    } catch (e) {
      print('❌ Erro ao salvar vacinação: $e');
      rethrow;
    }
  }

  // ✅ Método simplificado para criar vacinação (mantém compatibilidade)
  @action
  Future<void> criarVacinacao(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    // Atualizar a vacinação atual
    vacinacao.setTitulo(titulo);
    vacinacao.setDescricao(descricao);
    vacinacao.setDataVacinacao(data);
    vacinacao.setImagem(imagem);

    // Salvar usando o método principal
    await salvarVacinacao();
  }

  // ✅ Método para criar vacinação com imagem (mantém compatibilidade)
  @action
  Future<void> criarVacinacaoComImagem(String titulo, String descricao, String data, String imagePath) async {
    if (animalSelecionadoId == null) return;

    try {
      final novaVacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
      novaVacinacao.id = const Uuid().v4();
      novaVacinacao.setTitulo(titulo);
      novaVacinacao.setDescricao(descricao);
      novaVacinacao.setDataVacinacao(data);

      print('💉 Criando vacinação com imagem...');
      print('🐾 Animal: $animalSelecionadoNome');

      await _service.saveOrUpdateWithImage(novaVacinacao.toModel(), imagePath);

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(novaVacinacao);

      await loadVacinacoesByAnimal(animalSelecionadoId!);
    } catch (e) {
      print('❌ Erro ao criar vacinação com imagem: $e');
      rethrow;
    }
  }

  // ✅ Marcar vacinação como concluída (funcionalidade específica)
  @action
  Future<void> marcarComoConcluida(VacinacaoStore vacinacaoStore, bool concluida) async {
    try {
      vacinacaoStore.setConcluida(concluida);
      await _service.saveOrUpdate(vacinacaoStore.toModel());

      if (animalSelecionadoId != null) {
        await loadVacinacoesByAnimal(animalSelecionadoId!);
      }

      print('✅ Vacinação ${concluida ? "marcada como concluída" : "desmarcada"}');
    } catch (e) {
      print('❌ Erro ao marcar vacinação: $e');
      rethrow;
    }
  }

  @action
  Future<void> excluirVacinacao(VacinacaoStore vacinacaoParaExcluir) async {
    await _notificacoesService.cancelVacinacaoNotification(vacinacaoParaExcluir.id);
    await _service.delete(vacinacaoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadVacinacoesByAnimal(animalSelecionadoId!);
    }
  }

  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      vacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
    }
  }

  Future<void> _scheduleNotificacaoIfEnabled(VacinacaoStore vacinacao) async {
    final isEnabled = await _settingsService.isVacinacaoEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de vacinação desabilitadas');
      return;
    }

    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('💉 Agendando notificação de vacinação...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleVacinacaoNotification(
      vacinacaoId: vacinacao.id,
      titulo: vacinacao.titulo,
      descricao: vacinacao.descricao,
      dataVacinacao: vacinacao.dataVacinacao,
      animalNome: animalNome,
      animalId: vacinacao.animalId,
    );
  }
}

import 'package:cuidar_pet_app/app/modules/exame/services/exame_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/exame/store/exame_store.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_service.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'exame_controller.g.dart';

class ExameController = _ExameControllerBase with _$ExameController;

abstract class _ExameControllerBase with Store {
  final IExameService _service;
  final NotificacoesService _notificacoesService = NotificacoesService();
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  @observable
  ExameStore exame = ExameStoreFactory.novo('');

  @observable
  ObservableList<ExameStore> exames = ObservableList<ExameStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  String? animalSelecionadoNome;

  @observable
  bool isLoading = false;

  _ExameControllerBase(this._service);

  // ✅ Usar a validação do ExameStore
  @computed
  bool get isFormValid => exame.isFormValid;

  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome;
    exame = ExameStoreFactory.novo(animalId);
    loadExamesByAnimal(animalId);
  }

  @action
  Future<void> loadExamesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      exames.clear();

      for (var exame in list) {
        exames.add(ExameStoreFactory.fromModel(exame));
      }
    } finally {
      isLoading = false;
    }
  }

  // ✅ Método principal para salvar exame (com ou sem imagem)
  @action
  Future<void> salvarExame() async {
    if (animalSelecionadoId == null || !isFormValid) {
      print('❌ Não é possível salvar: animalId=${animalSelecionadoId}, isValid=${isFormValid}');
      return;
    }

    try {
      // Gerar ID se não existir
      if (exame.id.isEmpty) {
        exame.id = const Uuid().v4();
      }

      exame.animalId = animalSelecionadoId!;

      print('💾 Salvando exame:');
      print('  - ID: ${exame.id}');
      print('  - Título: ${exame.titulo}');
      print('  - Descrição: ${exame.descricao}');
      print('  - Data: ${exame.dataRealizacao}');
      print('  - Imagem: ${exame.imagem ?? "SEM IMAGEM"}');

      // ✅ Salvar sempre usando o método básico (funciona com ou sem imagem)
      await _service.saveOrUpdate(exame.toModel());

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(exame);

      await loadExamesByAnimal(animalSelecionadoId!);
      resetForm();

      print('✅ Exame salvo com sucesso!');
    } catch (e) {
      print('❌ Erro ao salvar exame: $e');
      rethrow;
    }
  }

  // ✅ Método simplificado para criar exame (mantém compatibilidade)
  @action
  Future<void> criarExame(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    // Atualizar o exame atual
    exame.setTitulo(titulo);
    exame.setDescricao(descricao);
    exame.setDataRealizacao(data);
    exame.setImagem(imagem);

    // Salvar usando o método principal
    await salvarExame();
  }

  // ✅ Método para criar exame com imagem (mantém compatibilidade)
  @action
  Future<void> criarExameComImagem(String titulo, String descricao, String data, String imagePath) async {
    if (animalSelecionadoId == null) return;

    try {
      final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
      novoExame.id = const Uuid().v4();
      novoExame.setTitulo(titulo);
      novoExame.setDescricao(descricao);
      novoExame.setDataRealizacao(data);

      print('🔬 Criando exame com imagem...');
      print('🐾 Animal: $animalSelecionadoNome');

      await _service.saveOrUpdateWithImage(novoExame.toModel(), imagePath);

      // Agendar notificação se estiver habilitada
      await _scheduleNotificacaoIfEnabled(novoExame);

      await loadExamesByAnimal(animalSelecionadoId!);
    } catch (e) {
      print('❌ Erro ao criar exame com imagem: $e');
      rethrow;
    }
  }

  @action
  Future<void> excluirExame(ExameStore exameParaExcluir) async {
    await _notificacoesService.cancelExameNotification(exameParaExcluir.id);
    await _service.delete(exameParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadExamesByAnimal(animalSelecionadoId!);
    }
  }

  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      exame = ExameStoreFactory.novo(animalSelecionadoId!);
    }
  }

  Future<void> _scheduleNotificacaoIfEnabled(ExameStore exame) async {
    final isEnabled = await _settingsService.isExameEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de exame desabilitadas');
      return;
    }

    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('🔬 Agendando notificação de exame...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleExameNotification(
      exameId: exame.id,
      titulo: exame.titulo,
      descricao: exame.descricao,
      dataRealizacao: exame.dataRealizacao,
      animalNome: animalNome,
      animalId: exame.animalId,
    );
  }
}

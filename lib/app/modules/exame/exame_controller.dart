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
  String? animalSelecionadoNome; // ✅ IGUAL AO ID - só uma variável simples

  @observable
  bool isLoading = false;

  _ExameControllerBase(this._service);

  @computed
  bool get isFormValid {
    final e = exame;
    return e.titulo.isNotEmpty &&
        e.descricao.isNotEmpty &&
        e.dataRealizacao.isNotEmpty &&
        e.animalId.isNotEmpty;
  }

  // ✅ Definir animal selecionado - IGUAL AO ID, mas agora recebe nome também
  @action
  void setAnimalSelecionado(String animalId, String animalNome) {
    animalSelecionadoId = animalId;
    animalSelecionadoNome = animalNome; // ✅ IGUAL AO ID
    exame = ExameStoreFactory.novo(animalId);
    loadExamesByAnimal(animalId);
  }

  // Carregar exames do animal selecionado
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

  // Salvar exame
  @action
  Future<void> salvarExame() async {
    if (animalSelecionadoId == null) return;

    // Gerar ID se não existir
    if (exame.id.isEmpty) {
      exame.id = const Uuid().v4();
    }

    exame.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(exame.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(exame);

    await loadExamesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar novo exame com imagem
  @action
  Future<void> criarExameComImagem(String titulo, String descricao, String data, String imagePath) async {
    if (animalSelecionadoId == null) return;

    final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novoExame.id = const Uuid().v4();
    novoExame.titulo = titulo;
    novoExame.descricao = descricao;
    novoExame.dataRealizacao = data;

    print('🔬 Criando exame com ID: ${novoExame.id}');
    print('🐾 Animal: $animalSelecionadoNome');

    await _service.saveOrUpdateWithImage(novoExame.toModel(), imagePath);

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novoExame);

    await loadExamesByAnimal(animalSelecionadoId!);
  }

  // Criar novo exame sem imagem (mantém compatibilidade)
  @action
  Future<void> criarExame(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novoExame.id = const Uuid().v4();
    novoExame.titulo = titulo;
    novoExame.descricao = descricao;
    novoExame.dataRealizacao = data;
    novoExame.imagem = imagem;

    print('🔬 Criando exame com ID: ${novoExame.id}');
    print('🐾 Animal: $animalSelecionadoNome');

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novoExame.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novoExame.toModel());
    }

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novoExame);

    await loadExamesByAnimal(animalSelecionadoId!);
  }

  // Excluir exame específico
  @action
  Future<void> excluirExame(ExameStore exameParaExcluir) async {
    // Cancelar notificação agendada
    await _notificacoesService.cancelExameNotification(exameParaExcluir.id);

    await _service.delete(exameParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadExamesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      exame = ExameStoreFactory.novo(animalSelecionadoId!);
    }
  }

  // ✅ Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(ExameStore exame) async {
    final isEnabled = await _settingsService.isExameEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de exame desabilitadas');
      return;
    }

    // ✅ Usar o nome do animal selecionado - IGUAL AO ID
    final animalNome = animalSelecionadoNome ?? 'Pet';

    print('🔬 Agendando notificação de exame...');
    print('🐾 Animal: $animalNome');

    await _notificacoesService.scheduleExameNotification(
      exameId: exame.id,
      titulo: exame.titulo,
      descricao: exame.descricao,
      dataRealizacao: exame.dataRealizacao,
      animalNome: animalNome, // ✅ USAR A VARIÁVEL DIRETAMENTE
      animalId: exame.animalId,
    );
  }
}

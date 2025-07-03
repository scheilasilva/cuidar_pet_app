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

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
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

  // NOVO: Criar novo exame com imagem
  @action
  Future<void> criarExameComImagem(String titulo, String descricao, String data, String imagePath) async {
    if (animalSelecionadoId == null) return;

    final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novoExame.id = const Uuid().v4();
    novoExame.titulo = titulo;
    novoExame.descricao = descricao;
    novoExame.dataRealizacao = data;

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

  // Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(ExameStore exame) async {
    final isEnabled = await _settingsService.isExameEnabled();
    if (!isEnabled) return;

    // Aqui você precisaria obter o nome do animal
    // Assumindo que você tem acesso ao AnimalController ou pode buscar o nome
    final animalNome = await _getAnimalNome(exame.animalId);

    await _notificacoesService.scheduleExameNotification(
      exameId: exame.id,
      titulo: exame.titulo,
      descricao: exame.descricao,
      dataRealizacao: exame.dataRealizacao,
      animalNome: animalNome,
      animalId: exame.animalId,
    );
  }

  // Método para obter o nome do animal (você precisa implementar isso)
  Future<String> _getAnimalNome(String animalId) async {
    // Implementar busca do nome do animal pelo ID
    // Por exemplo, usando o AnimalController ou um service
    return 'Pet'; // Placeholder
  }
}

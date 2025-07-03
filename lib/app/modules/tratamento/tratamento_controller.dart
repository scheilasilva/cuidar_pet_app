import 'package:cuidar_pet_app/app/modules/tratamento/services/tratamento_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/tratamento/store/tratamento_store.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_service.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'tratamento_controller.g.dart';

class TratamentoController = _TratamentoControllerBase with _$TratamentoController;

abstract class _TratamentoControllerBase with Store {
  final ITratamentoService _service;
  final NotificacoesService _notificacoesService = NotificacoesService();
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  @observable
  TratamentoStore tratamento = TratamentoStoreFactory.novo('');

  @observable
  ObservableList<TratamentoStore> tratamentosEmAndamento = ObservableList<TratamentoStore>();

  @observable
  ObservableList<TratamentoStore> tratamentosConcluidos = ObservableList<TratamentoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _TratamentoControllerBase(this._service);

  @computed
  bool get isFormValid {
    final t = tratamento;
    return t.titulo.isNotEmpty &&
        t.descricao.isNotEmpty &&
        t.dataInicio.isNotEmpty &&
        t.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    tratamento = TratamentoStoreFactory.novo(animalId);
    loadTratamentosByAnimal(animalId);
  }

  // Carregar tratamentos do animal selecionado
  @action
  Future<void> loadTratamentosByAnimal(String animalId) async {
    try {
      isLoading = true;

      // Carregar tratamentos em andamento
      final listEmAndamento = await _service.getByAnimalIdAndStatus(animalId, false);
      tratamentosEmAndamento.clear();
      for (var tratamento in listEmAndamento) {
        tratamentosEmAndamento.add(TratamentoStoreFactory.fromModel(tratamento));
      }

      // Carregar tratamentos concluídos
      final listConcluidos = await _service.getByAnimalIdAndStatus(animalId, true);
      tratamentosConcluidos.clear();
      for (var tratamento in listConcluidos) {
        tratamentosConcluidos.add(TratamentoStoreFactory.fromModel(tratamento));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar tratamento
  @action
  Future<void> salvarTratamento() async {
    if (animalSelecionadoId == null) return;

    // Gerar ID se não existir
    if (tratamento.id.isEmpty) {
      tratamento.id = const Uuid().v4();
    }

    tratamento.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(tratamento.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(tratamento);

    await loadTratamentosByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar novo tratamento
  @action
  Future<void> criarTratamento(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novoTratamento = TratamentoStoreFactory.novo(animalSelecionadoId!);
    // Gerar ID antes de salvar
    novoTratamento.id = const Uuid().v4();
    novoTratamento.titulo = titulo;
    novoTratamento.descricao = descricao;
    novoTratamento.dataInicio = data;
    novoTratamento.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novoTratamento.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novoTratamento.toModel());
    }

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novoTratamento);

    await loadTratamentosByAnimal(animalSelecionadoId!);
  }

  // Marcar/desmarcar tratamento como concluído
  @action
  Future<void> toggleTratamentoConcluido(TratamentoStore tratamentoStore) async {
    tratamentoStore.concluido = !tratamentoStore.concluido;
    await _service.saveOrUpdate(tratamentoStore.toModel());

    if (animalSelecionadoId != null) {
      await loadTratamentosByAnimal(animalSelecionadoId!);
    }
  }

  // Excluir tratamento específico
  @action
  Future<void> excluirTratamento(TratamentoStore tratamentoParaExcluir) async {
    // Cancelar notificação agendada
    await _notificacoesService.cancelTratamentoNotification(tratamentoParaExcluir.id);

    await _service.delete(tratamentoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadTratamentosByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      tratamento = TratamentoStoreFactory.novo(animalSelecionadoId!);
    }
  }

  // Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(TratamentoStore tratamento) async {
    final isEnabled = await _settingsService.isTratamentoEnabled();
    if (!isEnabled) return;

    // Aqui você precisaria obter o nome do animal
    // Assumindo que você tem acesso ao AnimalController ou pode buscar o nome
    final animalNome = await _getAnimalNome(tratamento.animalId);

    await _notificacoesService.scheduleTratamentoNotification(
      tratamentoId: tratamento.id,
      titulo: tratamento.titulo,
      descricao: tratamento.descricao,
      dataInicio: tratamento.dataInicio,
      animalNome: animalNome,
      animalId: tratamento.animalId,
    );
  }

  // Método para obter o nome do animal (você precisa implementar isso)
  Future<String> _getAnimalNome(String animalId) async {
    // Implementar busca do nome do animal pelo ID
    // Por exemplo, usando o AnimalController ou um service
    return 'Pet'; // Placeholder
  }
}

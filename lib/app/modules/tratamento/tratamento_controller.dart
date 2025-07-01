import 'package:cuidar_pet_app/app/modules/tratamento/services/tratamento_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/tratamento/store/tratamento_store.dart';
import 'package:mobx/mobx.dart';

part 'tratamento_controller.g.dart';

class TratamentoController = _TratamentoControllerBase with _$TratamentoController;

abstract class _TratamentoControllerBase with Store {
  final ITratamentoService _service;

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

    tratamento.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(tratamento.toModel());
    await loadTratamentosByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar novo tratamento
  @action
  Future<void> criarTratamento(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novoTratamento = TratamentoStoreFactory.novo(animalSelecionadoId!);
    novoTratamento.titulo = titulo;
    novoTratamento.descricao = descricao;
    novoTratamento.dataInicio = data;
    novoTratamento.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novoTratamento.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novoTratamento.toModel());
    }

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
}
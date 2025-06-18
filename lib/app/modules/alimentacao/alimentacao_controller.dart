import 'package:cuidar_pet_app/app/modules/alimentacao/services/alimentacao_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/alimentacao/store/alimentacao_store.dart';
import 'package:mobx/mobx.dart';

part 'alimentacao_controller.g.dart';

class AlimentacaoController = _AlimentacaoControllerBase with _$AlimentacaoController;

abstract class _AlimentacaoControllerBase with Store {
  final IAlimentacaoService _service;

  @observable
  AlimentacaoStore alimentacao = AlimentacaoStoreFactory.novo('');

  @observable
  ObservableList<AlimentacaoStore> alimentacoes = ObservableList<AlimentacaoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _AlimentacaoControllerBase(this._service);

  @computed
  bool get isFormValid {
    final a = alimentacao;
    return a.titulo.isNotEmpty &&
        a.horario.isNotEmpty &&
        a.alimento.isNotEmpty &&
        a.observacao.isNotEmpty &&
        a.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    alimentacao = AlimentacaoStoreFactory.novo(animalId);
    loadAlimentacoesByAnimal(animalId);
  }

  // Carregar alimentações do animal selecionado
  @action
  Future<void> loadAlimentacoesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      alimentacoes.clear();

      for (var alimentacao in list) {
        alimentacoes.add(AlimentacaoStoreFactory.fromModel(alimentacao));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar alimentação
  @action
  Future<void> salvarAlimentacao() async {
    if (animalSelecionadoId == null) return;

    alimentacao.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(alimentacao.toModel());
    await loadAlimentacoesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova alimentação
  @action
  Future<void> criarAlimentacao(String titulo, String horario, String alimento, String observacao) async {
    if (animalSelecionadoId == null) return;

    final novaAlimentacao = AlimentacaoStoreFactory.novo(animalSelecionadoId!);
    novaAlimentacao.titulo = titulo;
    novaAlimentacao.horario = horario;
    novaAlimentacao.alimento = alimento;
    novaAlimentacao.observacao = observacao;

    await _service.saveOrUpdate(novaAlimentacao.toModel());
    await loadAlimentacoesByAnimal(animalSelecionadoId!);
  }

  // Excluir alimentação específica
  @action
  Future<void> excluirAlimentacao(AlimentacaoStore alimentacaoParaExcluir) async {
    await _service.delete(alimentacaoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadAlimentacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      alimentacao = AlimentacaoStoreFactory.novo(animalSelecionadoId!);
    }
  }
}

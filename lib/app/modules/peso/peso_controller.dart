import 'package:cuidar_pet_app/app/modules/peso/services/peso_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/peso/store/peso_store.dart';
import 'package:mobx/mobx.dart';

part 'peso_controller.g.dart';

class PesoController = _PesoControllerBase with _$PesoController;

abstract class _PesoControllerBase with Store {
  final IPesoService _service;

  @observable
  PesoStore peso = PesoStoreFactory.novo('');

  @observable
  ObservableList<PesoStore> pesos = ObservableList<PesoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  @observable
  double pesoSelecionado = 0.0;

  _PesoControllerBase(this._service);

  @computed
  bool get isFormValid {
    return pesoSelecionado > 0 && animalSelecionadoId != null;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    peso = PesoStoreFactory.novo(animalId);
    loadPesosByAnimal(animalId);
    loadUltimoPeso(animalId);
  }

  // Carregar pesos do animal selecionado
  @action
  Future<void> loadPesosByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      pesos.clear();

      for (var peso in list) {
        pesos.add(PesoStoreFactory.fromModel(peso));
      }
    } finally {
      isLoading = false;
    }
  }

  // Carregar último peso para inicializar o slider
  @action
  Future<void> loadUltimoPeso(String animalId) async {
    try {
      final ultimoPeso = await _service.getUltimoPesoByAnimalId(animalId);
      if (ultimoPeso != null) {
        pesoSelecionado = ultimoPeso.peso;
      } else {
        pesoSelecionado = 5.0; // Valor padrão
      }
    } catch (e) {
      pesoSelecionado = 5.0; // Valor padrão em caso de erro
    }
  }

  // Definir peso selecionado no slider
  @action
  void setPesoSelecionado(double novoPeso) {
    pesoSelecionado = novoPeso;
  }

  // Salvar novo peso
  @action
  Future<void> salvarPeso() async {
    if (animalSelecionadoId == null || pesoSelecionado <= 0) return;

    final novoPeso = PesoStoreFactory.novo(animalSelecionadoId!);
    novoPeso.peso = pesoSelecionado;
    novoPeso.dataPesagem = DateTime.now();

    await _service.saveOrUpdate(novoPeso.toModel());
    await loadPesosByAnimal(animalSelecionadoId!);
  }

  // Criar novo peso com data específica
  @action
  Future<void> criarPeso(double peso, DateTime data, String? observacao) async {
    if (animalSelecionadoId == null) return;

    final novoPeso = PesoStoreFactory.novo(animalSelecionadoId!);
    novoPeso.peso = peso;
    novoPeso.dataPesagem = data;
    novoPeso.observacao = observacao;

    await _service.saveOrUpdate(novoPeso.toModel());
    await loadPesosByAnimal(animalSelecionadoId!);
  }

  // Excluir peso específico
  @action
  Future<void> excluirPeso(PesoStore pesoParaExcluir) async {
    await _service.delete(pesoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadPesosByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      peso = PesoStoreFactory.novo(animalSelecionadoId!);
      loadUltimoPeso(animalSelecionadoId!);
    }
  }

  // Obter variação de peso (comparado com o peso anterior)
  String getVariacaoPeso(int index) {
    if (index >= pesos.length - 1) return '';

    final pesoAtual = pesos[index].peso;
    final pesoAnterior = pesos[index + 1].peso;
    final diferenca = pesoAtual - pesoAnterior;

    if (diferenca > 0) {
      return '+${diferenca.toStringAsFixed(1)} KG';
    } else if (diferenca < 0) {
      return '${diferenca.toStringAsFixed(1)} KG';
    } else {
      return '0.0 KG';
    }
  }
}

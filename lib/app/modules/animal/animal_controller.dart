import 'package:cuidar_pet_app/app/modules/animal/services/animal_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/animal/store/animal_store.dart';
import 'package:mobx/mobx.dart';

part 'animal_controller.g.dart';

class AnimalController = _AnimalControllerBase with _$AnimalController;

abstract class _AnimalControllerBase with Store {
  final IAnimalService _service;

  @observable
  AnimalStore animal = AnimalStoreFactory.novo();

  @observable
  ObservableList<AnimalStore> animais = ObservableList<AnimalStore>();

  // NOVO: Animal selecionado no carrossel
  @observable
  AnimalStore? animalSelecionadoCarrossel;

  // NOVO: Índice do carrossel selecionado
  @observable
  int carrosselIndex = 0;

  _AnimalControllerBase(this._service);

  @computed
  bool get isFormValid {
    final a = animal;
    return a.nome.isNotEmpty &&
        a.tipoAnimal.isNotEmpty &&
        a.idade > 0 &&
        a.peso > 0 &&
        a.genero.isNotEmpty;
  }

  // NOVO: Método para definir animal selecionado no carrossel
  @action
  void setAnimalSelecionadoCarrossel(int index) {
    if (index >= 0 && index < animais.length) {
      carrosselIndex = index;
      animalSelecionadoCarrossel = animais[index];
    }
  }

  // Carregar todos os animais
  @action
  Future<void> loadAnimais() async {
    final list = await _service.getAll();
    animais.clear();

    for (var animal in list) {
      animais.add(AnimalStoreFactory.fromModel(animal));
    }

    // Ajustar seleção após carregar
    if (animais.isNotEmpty) {
      // Se o índice atual é válido, manter
      if (carrosselIndex < animais.length) {
        animalSelecionadoCarrossel = animais[carrosselIndex];
      } else {
        // Senão, selecionar o primeiro
        carrosselIndex = 0;
        animalSelecionadoCarrossel = animais.first;
      }
    } else {
      animalSelecionadoCarrossel = null;
      carrosselIndex = 0;
    }
  }

  // Salvar animal (usado no formulário de cadastro)
  @action
  Future<void> salvarAnimal() async {
    await _service.saveOrUpdate(animal.toModel());
    await loadAnimais();
    resetForm();
  }

  // Atualizar animal específico (usado no bottom sheet de edição)
  @action
  Future<void> atualizarAnimal(AnimalStore animalParaAtualizar) async {
    await _service.saveOrUpdate(animalParaAtualizar.toModel());
    await loadAnimais();
  }

  // Excluir animal específico
  @action
  Future<void> excluirAnimal(AnimalStore animalParaExcluir) async {
    await _service.delete(animalParaExcluir.toModel());

    // Se o animal excluído era o selecionado, ajustar seleção
    if (animalSelecionadoCarrossel?.id == animalParaExcluir.id) {
      carrosselIndex = 0;
    }

    await loadAnimais();
  }

  // Resetar formulário
  @action
  void resetForm() {
    animal = AnimalStoreFactory.novo();
  }
}
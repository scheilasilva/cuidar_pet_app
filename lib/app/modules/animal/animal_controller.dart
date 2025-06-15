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

  // Carregar todos os animais
  Future<void> loadAnimais() async {
    final list = await _service.getAll();
    animais.clear();

    for (var animal in list) {
      animais.add(AnimalStoreFactory.fromModel(animal));
    }
  }

  // Salvar animal
  @action
  Future<void> salvarAnimal() async {
    await _service.saveOrUpdate(animal.toModel());
    await loadAnimais();
    resetForm();
  }

  // Resetar formulário
  @action
  void resetForm() {
    animal = AnimalStoreFactory.novo();
  }
}
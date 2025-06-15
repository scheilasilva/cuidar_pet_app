import 'package:mobx/mobx.dart';
import '../models/animal_model.dart';

part 'animal_store.g.dart';

class AnimalStore = _AnimalStoreBase with _$AnimalStore;

abstract class AnimalStoreFactory {
  static AnimalStore fromModel(AnimalModel model) => AnimalStore(
    id: model.id,
    nome: model.nome,
    imagem: model.imagem,
    tipoAnimal: model.tipoAnimal,
    idade: model.idade,
    genero: model.genero,
    peso: model.peso,
  );

  static AnimalStore novo() => AnimalStore(
    id: '',
    nome: '',
    imagem: null,
    tipoAnimal: '',
    idade: 0,
    genero: 'Macho',
    peso: 0.0,
  );
}

abstract class _AnimalStoreBase with Store {
  @observable
  String id;

  @observable
  String nome;

  @observable
  String? imagem;

  @observable
  String tipoAnimal;

  @observable
  int idade;

  @observable
  String genero;

  @observable
  double peso;

  _AnimalStoreBase({
    required this.id,
    required this.nome,
    this.imagem,
    required this.tipoAnimal,
    required this.idade,
    required this.genero,
    required this.peso,
  });

  AnimalModel toModel() {
    return AnimalModel(
      id: id,
      nome: nome,
      imagem: imagem,
      tipoAnimal: tipoAnimal,
      idade: idade,
      genero: genero,
      peso: peso,
    );
  }
}
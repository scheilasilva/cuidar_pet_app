// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnimalController on _AnimalControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_AnimalControllerBase.isFormValid'))
          .value;

  late final _$animalAtom =
      Atom(name: '_AnimalControllerBase.animal', context: context);

  @override
  AnimalStore get animal {
    _$animalAtom.reportRead();
    return super.animal;
  }

  @override
  set animal(AnimalStore value) {
    _$animalAtom.reportWrite(value, super.animal, () {
      super.animal = value;
    });
  }

  late final _$animaisAtom =
      Atom(name: '_AnimalControllerBase.animais', context: context);

  @override
  ObservableList<AnimalStore> get animais {
    _$animaisAtom.reportRead();
    return super.animais;
  }

  @override
  set animais(ObservableList<AnimalStore> value) {
    _$animaisAtom.reportWrite(value, super.animais, () {
      super.animais = value;
    });
  }

  late final _$salvarAnimalAsyncAction =
      AsyncAction('_AnimalControllerBase.salvarAnimal', context: context);

  @override
  Future<void> salvarAnimal() {
    return _$salvarAnimalAsyncAction.run(() => super.salvarAnimal());
  }

  late final _$atualizarAnimalAsyncAction =
      AsyncAction('_AnimalControllerBase.atualizarAnimal', context: context);

  @override
  Future<void> atualizarAnimal(AnimalStore animalParaAtualizar) {
    return _$atualizarAnimalAsyncAction
        .run(() => super.atualizarAnimal(animalParaAtualizar));
  }

  late final _$excluirAnimalAsyncAction =
      AsyncAction('_AnimalControllerBase.excluirAnimal', context: context);

  @override
  Future<void> excluirAnimal(AnimalStore animalParaExcluir) {
    return _$excluirAnimalAsyncAction
        .run(() => super.excluirAnimal(animalParaExcluir));
  }

  late final _$_AnimalControllerBaseActionController =
      ActionController(name: '_AnimalControllerBase', context: context);

  @override
  void resetForm() {
    final _$actionInfo = _$_AnimalControllerBaseActionController.startAction(
        name: '_AnimalControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_AnimalControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
animal: ${animal},
animais: ${animais},
isFormValid: ${isFormValid}
    ''';
  }
}

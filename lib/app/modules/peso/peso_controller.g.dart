// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peso_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PesoController on _PesoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_PesoControllerBase.isFormValid'))
          .value;

  late final _$pesoAtom =
      Atom(name: '_PesoControllerBase.peso', context: context);

  @override
  PesoStore get peso {
    _$pesoAtom.reportRead();
    return super.peso;
  }

  @override
  set peso(PesoStore value) {
    _$pesoAtom.reportWrite(value, super.peso, () {
      super.peso = value;
    });
  }

  late final _$pesosAtom =
      Atom(name: '_PesoControllerBase.pesos', context: context);

  @override
  ObservableList<PesoStore> get pesos {
    _$pesosAtom.reportRead();
    return super.pesos;
  }

  @override
  set pesos(ObservableList<PesoStore> value) {
    _$pesosAtom.reportWrite(value, super.pesos, () {
      super.pesos = value;
    });
  }

  late final _$animalSelecionadoIdAtom =
      Atom(name: '_PesoControllerBase.animalSelecionadoId', context: context);

  @override
  String? get animalSelecionadoId {
    _$animalSelecionadoIdAtom.reportRead();
    return super.animalSelecionadoId;
  }

  @override
  set animalSelecionadoId(String? value) {
    _$animalSelecionadoIdAtom.reportWrite(value, super.animalSelecionadoId, () {
      super.animalSelecionadoId = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PesoControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$pesoSelecionadoAtom =
      Atom(name: '_PesoControllerBase.pesoSelecionado', context: context);

  @override
  double get pesoSelecionado {
    _$pesoSelecionadoAtom.reportRead();
    return super.pesoSelecionado;
  }

  @override
  set pesoSelecionado(double value) {
    _$pesoSelecionadoAtom.reportWrite(value, super.pesoSelecionado, () {
      super.pesoSelecionado = value;
    });
  }

  late final _$loadPesosByAnimalAsyncAction =
      AsyncAction('_PesoControllerBase.loadPesosByAnimal', context: context);

  @override
  Future<void> loadPesosByAnimal(String animalId) {
    return _$loadPesosByAnimalAsyncAction
        .run(() => super.loadPesosByAnimal(animalId));
  }

  late final _$loadUltimoPesoAsyncAction =
      AsyncAction('_PesoControllerBase.loadUltimoPeso', context: context);

  @override
  Future<void> loadUltimoPeso(String animalId) {
    return _$loadUltimoPesoAsyncAction
        .run(() => super.loadUltimoPeso(animalId));
  }

  late final _$salvarPesoAsyncAction =
      AsyncAction('_PesoControllerBase.salvarPeso', context: context);

  @override
  Future<void> salvarPeso() {
    return _$salvarPesoAsyncAction.run(() => super.salvarPeso());
  }

  late final _$criarPesoAsyncAction =
      AsyncAction('_PesoControllerBase.criarPeso', context: context);

  @override
  Future<void> criarPeso(double peso, DateTime data, String? observacao) {
    return _$criarPesoAsyncAction
        .run(() => super.criarPeso(peso, data, observacao));
  }

  late final _$excluirPesoAsyncAction =
      AsyncAction('_PesoControllerBase.excluirPeso', context: context);

  @override
  Future<void> excluirPeso(PesoStore pesoParaExcluir) {
    return _$excluirPesoAsyncAction
        .run(() => super.excluirPeso(pesoParaExcluir));
  }

  late final _$_PesoControllerBaseActionController =
      ActionController(name: '_PesoControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId) {
    final _$actionInfo = _$_PesoControllerBaseActionController.startAction(
        name: '_PesoControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId);
    } finally {
      _$_PesoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPesoSelecionado(double novoPeso) {
    final _$actionInfo = _$_PesoControllerBaseActionController.startAction(
        name: '_PesoControllerBase.setPesoSelecionado');
    try {
      return super.setPesoSelecionado(novoPeso);
    } finally {
      _$_PesoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_PesoControllerBaseActionController.startAction(
        name: '_PesoControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_PesoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
peso: ${peso},
pesos: ${pesos},
animalSelecionadoId: ${animalSelecionadoId},
isLoading: ${isLoading},
pesoSelecionado: ${pesoSelecionado},
isFormValid: ${isFormValid}
    ''';
  }
}

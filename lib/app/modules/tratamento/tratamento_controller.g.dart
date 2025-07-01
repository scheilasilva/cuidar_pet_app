// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tratamento_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TratamentoController on _TratamentoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_TratamentoControllerBase.isFormValid'))
          .value;

  late final _$tratamentoAtom =
      Atom(name: '_TratamentoControllerBase.tratamento', context: context);

  @override
  TratamentoStore get tratamento {
    _$tratamentoAtom.reportRead();
    return super.tratamento;
  }

  @override
  set tratamento(TratamentoStore value) {
    _$tratamentoAtom.reportWrite(value, super.tratamento, () {
      super.tratamento = value;
    });
  }

  late final _$tratamentosEmAndamentoAtom = Atom(
      name: '_TratamentoControllerBase.tratamentosEmAndamento',
      context: context);

  @override
  ObservableList<TratamentoStore> get tratamentosEmAndamento {
    _$tratamentosEmAndamentoAtom.reportRead();
    return super.tratamentosEmAndamento;
  }

  @override
  set tratamentosEmAndamento(ObservableList<TratamentoStore> value) {
    _$tratamentosEmAndamentoAtom
        .reportWrite(value, super.tratamentosEmAndamento, () {
      super.tratamentosEmAndamento = value;
    });
  }

  late final _$tratamentosConcluidosAtom = Atom(
      name: '_TratamentoControllerBase.tratamentosConcluidos',
      context: context);

  @override
  ObservableList<TratamentoStore> get tratamentosConcluidos {
    _$tratamentosConcluidosAtom.reportRead();
    return super.tratamentosConcluidos;
  }

  @override
  set tratamentosConcluidos(ObservableList<TratamentoStore> value) {
    _$tratamentosConcluidosAtom.reportWrite(value, super.tratamentosConcluidos,
        () {
      super.tratamentosConcluidos = value;
    });
  }

  late final _$animalSelecionadoIdAtom = Atom(
      name: '_TratamentoControllerBase.animalSelecionadoId', context: context);

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
      Atom(name: '_TratamentoControllerBase.isLoading', context: context);

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

  late final _$loadTratamentosByAnimalAsyncAction = AsyncAction(
      '_TratamentoControllerBase.loadTratamentosByAnimal',
      context: context);

  @override
  Future<void> loadTratamentosByAnimal(String animalId) {
    return _$loadTratamentosByAnimalAsyncAction
        .run(() => super.loadTratamentosByAnimal(animalId));
  }

  late final _$salvarTratamentoAsyncAction = AsyncAction(
      '_TratamentoControllerBase.salvarTratamento',
      context: context);

  @override
  Future<void> salvarTratamento() {
    return _$salvarTratamentoAsyncAction.run(() => super.salvarTratamento());
  }

  late final _$criarTratamentoAsyncAction = AsyncAction(
      '_TratamentoControllerBase.criarTratamento',
      context: context);

  @override
  Future<void> criarTratamento(
      String titulo, String descricao, String data, String? imagem) {
    return _$criarTratamentoAsyncAction
        .run(() => super.criarTratamento(titulo, descricao, data, imagem));
  }

  late final _$toggleTratamentoConcluidoAsyncAction = AsyncAction(
      '_TratamentoControllerBase.toggleTratamentoConcluido',
      context: context);

  @override
  Future<void> toggleTratamentoConcluido(TratamentoStore tratamentoStore) {
    return _$toggleTratamentoConcluidoAsyncAction
        .run(() => super.toggleTratamentoConcluido(tratamentoStore));
  }

  late final _$excluirTratamentoAsyncAction = AsyncAction(
      '_TratamentoControllerBase.excluirTratamento',
      context: context);

  @override
  Future<void> excluirTratamento(TratamentoStore tratamentoParaExcluir) {
    return _$excluirTratamentoAsyncAction
        .run(() => super.excluirTratamento(tratamentoParaExcluir));
  }

  late final _$_TratamentoControllerBaseActionController =
      ActionController(name: '_TratamentoControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId) {
    final _$actionInfo = _$_TratamentoControllerBaseActionController
        .startAction(name: '_TratamentoControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId);
    } finally {
      _$_TratamentoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_TratamentoControllerBaseActionController
        .startAction(name: '_TratamentoControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_TratamentoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tratamento: ${tratamento},
tratamentosEmAndamento: ${tratamentosEmAndamento},
tratamentosConcluidos: ${tratamentosConcluidos},
animalSelecionadoId: ${animalSelecionadoId},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

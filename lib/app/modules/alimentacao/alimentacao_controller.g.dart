// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimentacao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AlimentacaoController on _AlimentacaoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_AlimentacaoControllerBase.isFormValid'))
          .value;

  late final _$alimentacaoAtom =
      Atom(name: '_AlimentacaoControllerBase.alimentacao', context: context);

  @override
  AlimentacaoStore get alimentacao {
    _$alimentacaoAtom.reportRead();
    return super.alimentacao;
  }

  @override
  set alimentacao(AlimentacaoStore value) {
    _$alimentacaoAtom.reportWrite(value, super.alimentacao, () {
      super.alimentacao = value;
    });
  }

  late final _$alimentacoesAtom =
      Atom(name: '_AlimentacaoControllerBase.alimentacoes', context: context);

  @override
  ObservableList<AlimentacaoStore> get alimentacoes {
    _$alimentacoesAtom.reportRead();
    return super.alimentacoes;
  }

  @override
  set alimentacoes(ObservableList<AlimentacaoStore> value) {
    _$alimentacoesAtom.reportWrite(value, super.alimentacoes, () {
      super.alimentacoes = value;
    });
  }

  late final _$animalSelecionadoIdAtom = Atom(
      name: '_AlimentacaoControllerBase.animalSelecionadoId', context: context);

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
      Atom(name: '_AlimentacaoControllerBase.isLoading', context: context);

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

  late final _$loadAlimentacoesByAnimalAsyncAction = AsyncAction(
      '_AlimentacaoControllerBase.loadAlimentacoesByAnimal',
      context: context);

  @override
  Future<void> loadAlimentacoesByAnimal(String animalId) {
    return _$loadAlimentacoesByAnimalAsyncAction
        .run(() => super.loadAlimentacoesByAnimal(animalId));
  }

  late final _$salvarAlimentacaoAsyncAction = AsyncAction(
      '_AlimentacaoControllerBase.salvarAlimentacao',
      context: context);

  @override
  Future<void> salvarAlimentacao() {
    return _$salvarAlimentacaoAsyncAction.run(() => super.salvarAlimentacao());
  }

  late final _$criarAlimentacaoAsyncAction = AsyncAction(
      '_AlimentacaoControllerBase.criarAlimentacao',
      context: context);

  @override
  Future<void> criarAlimentacao(
      String titulo, String horario, String alimento, String observacao) {
    return _$criarAlimentacaoAsyncAction.run(
        () => super.criarAlimentacao(titulo, horario, alimento, observacao));
  }

  late final _$excluirAlimentacaoAsyncAction = AsyncAction(
      '_AlimentacaoControllerBase.excluirAlimentacao',
      context: context);

  @override
  Future<void> excluirAlimentacao(AlimentacaoStore alimentacaoParaExcluir) {
    return _$excluirAlimentacaoAsyncAction
        .run(() => super.excluirAlimentacao(alimentacaoParaExcluir));
  }

  late final _$_AlimentacaoControllerBaseActionController =
      ActionController(name: '_AlimentacaoControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId) {
    final _$actionInfo = _$_AlimentacaoControllerBaseActionController
        .startAction(name: '_AlimentacaoControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId);
    } finally {
      _$_AlimentacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_AlimentacaoControllerBaseActionController
        .startAction(name: '_AlimentacaoControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_AlimentacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
alimentacao: ${alimentacao},
alimentacoes: ${alimentacoes},
animalSelecionadoId: ${animalSelecionadoId},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

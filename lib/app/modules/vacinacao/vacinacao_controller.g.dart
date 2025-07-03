// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacinacao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VacinacaoController on _VacinacaoControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_VacinacaoControllerBase.isFormValid'))
          .value;

  late final _$vacinacaoAtom =
      Atom(name: '_VacinacaoControllerBase.vacinacao', context: context);

  @override
  VacinacaoStore get vacinacao {
    _$vacinacaoAtom.reportRead();
    return super.vacinacao;
  }

  @override
  set vacinacao(VacinacaoStore value) {
    _$vacinacaoAtom.reportWrite(value, super.vacinacao, () {
      super.vacinacao = value;
    });
  }

  late final _$vacinacoesAtom =
      Atom(name: '_VacinacaoControllerBase.vacinacoes', context: context);

  @override
  ObservableList<VacinacaoStore> get vacinacoes {
    _$vacinacoesAtom.reportRead();
    return super.vacinacoes;
  }

  @override
  set vacinacoes(ObservableList<VacinacaoStore> value) {
    _$vacinacoesAtom.reportWrite(value, super.vacinacoes, () {
      super.vacinacoes = value;
    });
  }

  late final _$animalSelecionadoIdAtom = Atom(
      name: '_VacinacaoControllerBase.animalSelecionadoId', context: context);

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

  late final _$animalSelecionadoNomeAtom = Atom(
      name: '_VacinacaoControllerBase.animalSelecionadoNome', context: context);

  @override
  String? get animalSelecionadoNome {
    _$animalSelecionadoNomeAtom.reportRead();
    return super.animalSelecionadoNome;
  }

  @override
  set animalSelecionadoNome(String? value) {
    _$animalSelecionadoNomeAtom.reportWrite(value, super.animalSelecionadoNome,
        () {
      super.animalSelecionadoNome = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_VacinacaoControllerBase.isLoading', context: context);

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

  late final _$loadVacinacoesByAnimalAsyncAction = AsyncAction(
      '_VacinacaoControllerBase.loadVacinacoesByAnimal',
      context: context);

  @override
  Future<void> loadVacinacoesByAnimal(String animalId) {
    return _$loadVacinacoesByAnimalAsyncAction
        .run(() => super.loadVacinacoesByAnimal(animalId));
  }

  late final _$salvarVacinacaoAsyncAction =
      AsyncAction('_VacinacaoControllerBase.salvarVacinacao', context: context);

  @override
  Future<void> salvarVacinacao() {
    return _$salvarVacinacaoAsyncAction.run(() => super.salvarVacinacao());
  }

  late final _$criarVacinacaoAsyncAction =
      AsyncAction('_VacinacaoControllerBase.criarVacinacao', context: context);

  @override
  Future<void> criarVacinacao(
      String titulo, String descricao, String data, String? imagem) {
    return _$criarVacinacaoAsyncAction
        .run(() => super.criarVacinacao(titulo, descricao, data, imagem));
  }

  late final _$marcarComoConcluidaAsyncAction = AsyncAction(
      '_VacinacaoControllerBase.marcarComoConcluida',
      context: context);

  @override
  Future<void> marcarComoConcluida(
      VacinacaoStore vacinacaoStore, bool concluida) {
    return _$marcarComoConcluidaAsyncAction
        .run(() => super.marcarComoConcluida(vacinacaoStore, concluida));
  }

  late final _$excluirVacinacaoAsyncAction = AsyncAction(
      '_VacinacaoControllerBase.excluirVacinacao',
      context: context);

  @override
  Future<void> excluirVacinacao(VacinacaoStore vacinacaoParaExcluir) {
    return _$excluirVacinacaoAsyncAction
        .run(() => super.excluirVacinacao(vacinacaoParaExcluir));
  }

  late final _$_VacinacaoControllerBaseActionController =
      ActionController(name: '_VacinacaoControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId, String animalNome) {
    final _$actionInfo = _$_VacinacaoControllerBaseActionController.startAction(
        name: '_VacinacaoControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId, animalNome);
    } finally {
      _$_VacinacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_VacinacaoControllerBaseActionController.startAction(
        name: '_VacinacaoControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_VacinacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
vacinacao: ${vacinacao},
vacinacoes: ${vacinacoes},
animalSelecionadoId: ${animalSelecionadoId},
animalSelecionadoNome: ${animalSelecionadoNome},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

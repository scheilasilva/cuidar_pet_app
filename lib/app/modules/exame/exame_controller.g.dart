// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exame_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExameController on _ExameControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_ExameControllerBase.isFormValid'))
          .value;

  late final _$exameAtom =
      Atom(name: '_ExameControllerBase.exame', context: context);

  @override
  ExameStore get exame {
    _$exameAtom.reportRead();
    return super.exame;
  }

  @override
  set exame(ExameStore value) {
    _$exameAtom.reportWrite(value, super.exame, () {
      super.exame = value;
    });
  }

  late final _$examesAtom =
      Atom(name: '_ExameControllerBase.exames', context: context);

  @override
  ObservableList<ExameStore> get exames {
    _$examesAtom.reportRead();
    return super.exames;
  }

  @override
  set exames(ObservableList<ExameStore> value) {
    _$examesAtom.reportWrite(value, super.exames, () {
      super.exames = value;
    });
  }

  late final _$animalSelecionadoIdAtom =
      Atom(name: '_ExameControllerBase.animalSelecionadoId', context: context);

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
      name: '_ExameControllerBase.animalSelecionadoNome', context: context);

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
      Atom(name: '_ExameControllerBase.isLoading', context: context);

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

  late final _$loadExamesByAnimalAsyncAction =
      AsyncAction('_ExameControllerBase.loadExamesByAnimal', context: context);

  @override
  Future<void> loadExamesByAnimal(String animalId) {
    return _$loadExamesByAnimalAsyncAction
        .run(() => super.loadExamesByAnimal(animalId));
  }

  late final _$salvarExameAsyncAction =
      AsyncAction('_ExameControllerBase.salvarExame', context: context);

  @override
  Future<void> salvarExame() {
    return _$salvarExameAsyncAction.run(() => super.salvarExame());
  }

  late final _$criarExameComImagemAsyncAction =
      AsyncAction('_ExameControllerBase.criarExameComImagem', context: context);

  @override
  Future<void> criarExameComImagem(
      String titulo, String descricao, String data, String imagePath) {
    return _$criarExameComImagemAsyncAction.run(
        () => super.criarExameComImagem(titulo, descricao, data, imagePath));
  }

  late final _$criarExameAsyncAction =
      AsyncAction('_ExameControllerBase.criarExame', context: context);

  @override
  Future<void> criarExame(
      String titulo, String descricao, String data, String? imagem) {
    return _$criarExameAsyncAction
        .run(() => super.criarExame(titulo, descricao, data, imagem));
  }

  late final _$excluirExameAsyncAction =
      AsyncAction('_ExameControllerBase.excluirExame', context: context);

  @override
  Future<void> excluirExame(ExameStore exameParaExcluir) {
    return _$excluirExameAsyncAction
        .run(() => super.excluirExame(exameParaExcluir));
  }

  late final _$_ExameControllerBaseActionController =
      ActionController(name: '_ExameControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId, String animalNome) {
    final _$actionInfo = _$_ExameControllerBaseActionController.startAction(
        name: '_ExameControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId, animalNome);
    } finally {
      _$_ExameControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_ExameControllerBaseActionController.startAction(
        name: '_ExameControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_ExameControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
exame: ${exame},
exames: ${exames},
animalSelecionadoId: ${animalSelecionadoId},
animalSelecionadoNome: ${animalSelecionadoNome},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

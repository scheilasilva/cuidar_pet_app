// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consulta_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConsultaController on _ConsultaControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_ConsultaControllerBase.isFormValid'))
          .value;

  late final _$consultaAtom =
      Atom(name: '_ConsultaControllerBase.consulta', context: context);

  @override
  ConsultaStore get consulta {
    _$consultaAtom.reportRead();
    return super.consulta;
  }

  @override
  set consulta(ConsultaStore value) {
    _$consultaAtom.reportWrite(value, super.consulta, () {
      super.consulta = value;
    });
  }

  late final _$consultasAtom =
      Atom(name: '_ConsultaControllerBase.consultas', context: context);

  @override
  ObservableList<ConsultaStore> get consultas {
    _$consultasAtom.reportRead();
    return super.consultas;
  }

  @override
  set consultas(ObservableList<ConsultaStore> value) {
    _$consultasAtom.reportWrite(value, super.consultas, () {
      super.consultas = value;
    });
  }

  late final _$animalSelecionadoIdAtom = Atom(
      name: '_ConsultaControllerBase.animalSelecionadoId', context: context);

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
      name: '_ConsultaControllerBase.animalSelecionadoNome', context: context);

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
      Atom(name: '_ConsultaControllerBase.isLoading', context: context);

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

  late final _$loadConsultasByAnimalAsyncAction = AsyncAction(
      '_ConsultaControllerBase.loadConsultasByAnimal',
      context: context);

  @override
  Future<void> loadConsultasByAnimal(String animalId) {
    return _$loadConsultasByAnimalAsyncAction
        .run(() => super.loadConsultasByAnimal(animalId));
  }

  late final _$salvarConsultaAsyncAction =
      AsyncAction('_ConsultaControllerBase.salvarConsulta', context: context);

  @override
  Future<void> salvarConsulta() {
    return _$salvarConsultaAsyncAction.run(() => super.salvarConsulta());
  }

  late final _$criarConsultaAsyncAction =
      AsyncAction('_ConsultaControllerBase.criarConsulta', context: context);

  @override
  Future<void> criarConsulta(
      String titulo, String descricao, String data, String? imagem) {
    return _$criarConsultaAsyncAction
        .run(() => super.criarConsulta(titulo, descricao, data, imagem));
  }

  late final _$criarConsultaComImagemAsyncAction = AsyncAction(
      '_ConsultaControllerBase.criarConsultaComImagem',
      context: context);

  @override
  Future<void> criarConsultaComImagem(
      String titulo, String descricao, String data, String imagePath) {
    return _$criarConsultaComImagemAsyncAction.run(
        () => super.criarConsultaComImagem(titulo, descricao, data, imagePath));
  }

  late final _$excluirConsultaAsyncAction =
      AsyncAction('_ConsultaControllerBase.excluirConsulta', context: context);

  @override
  Future<void> excluirConsulta(ConsultaStore consultaParaExcluir) {
    return _$excluirConsultaAsyncAction
        .run(() => super.excluirConsulta(consultaParaExcluir));
  }

  late final _$_ConsultaControllerBaseActionController =
      ActionController(name: '_ConsultaControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId, String animalNome) {
    final _$actionInfo = _$_ConsultaControllerBaseActionController.startAction(
        name: '_ConsultaControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId, animalNome);
    } finally {
      _$_ConsultaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_ConsultaControllerBaseActionController.startAction(
        name: '_ConsultaControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_ConsultaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
consulta: ${consulta},
consultas: ${consultas},
animalSelecionadoId: ${animalSelecionadoId},
animalSelecionadoNome: ${animalSelecionadoNome},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergencia_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EmergenciaController on _EmergenciaControllerBase, Store {
  late final _$veterinariosAtom =
      Atom(name: '_EmergenciaControllerBase.veterinarios', context: context);

  @override
  ObservableList<VeterinarioModel> get veterinarios {
    _$veterinariosAtom.reportRead();
    return super.veterinarios;
  }

  @override
  set veterinarios(ObservableList<VeterinarioModel> value) {
    _$veterinariosAtom.reportWrite(value, super.veterinarios, () {
      super.veterinarios = value;
    });
  }

  late final _$localizacaoAtualAtom = Atom(
      name: '_EmergenciaControllerBase.localizacaoAtual', context: context);

  @override
  Position? get localizacaoAtual {
    _$localizacaoAtualAtom.reportRead();
    return super.localizacaoAtual;
  }

  @override
  set localizacaoAtual(Position? value) {
    _$localizacaoAtualAtom.reportWrite(value, super.localizacaoAtual, () {
      super.localizacaoAtual = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_EmergenciaControllerBase.isLoading', context: context);

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

  late final _$isLoadingLocationAtom = Atom(
      name: '_EmergenciaControllerBase.isLoadingLocation', context: context);

  @override
  bool get isLoadingLocation {
    _$isLoadingLocationAtom.reportRead();
    return super.isLoadingLocation;
  }

  @override
  set isLoadingLocation(bool value) {
    _$isLoadingLocationAtom.reportWrite(value, super.isLoadingLocation, () {
      super.isLoadingLocation = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_EmergenciaControllerBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$veterinarioSelecionadoAtom = Atom(
      name: '_EmergenciaControllerBase.veterinarioSelecionado',
      context: context);

  @override
  VeterinarioModel? get veterinarioSelecionado {
    _$veterinarioSelecionadoAtom.reportRead();
    return super.veterinarioSelecionado;
  }

  @override
  set veterinarioSelecionado(VeterinarioModel? value) {
    _$veterinarioSelecionadoAtom
        .reportWrite(value, super.veterinarioSelecionado, () {
      super.veterinarioSelecionado = value;
    });
  }

  late final _$inicializarAsyncAction =
      AsyncAction('_EmergenciaControllerBase.inicializar', context: context);

  @override
  Future<void> inicializar() {
    return _$inicializarAsyncAction.run(() => super.inicializar());
  }

  late final _$obterLocalizacaoAsyncAction = AsyncAction(
      '_EmergenciaControllerBase.obterLocalizacao',
      context: context);

  @override
  Future<void> obterLocalizacao() {
    return _$obterLocalizacaoAsyncAction.run(() => super.obterLocalizacao());
  }

  late final _$buscarVeterinariosProximosAsyncAction = AsyncAction(
      '_EmergenciaControllerBase.buscarVeterinariosProximos',
      context: context);

  @override
  Future<void> buscarVeterinariosProximos() {
    return _$buscarVeterinariosProximosAsyncAction
        .run(() => super.buscarVeterinariosProximos());
  }

  late final _$buscarVeterinariosPorTextoAsyncAction = AsyncAction(
      '_EmergenciaControllerBase.buscarVeterinariosPorTexto',
      context: context);

  @override
  Future<void> buscarVeterinariosPorTexto(String query) {
    return _$buscarVeterinariosPorTextoAsyncAction
        .run(() => super.buscarVeterinariosPorTexto(query));
  }

  late final _$recarregarDadosAsyncAction = AsyncAction(
      '_EmergenciaControllerBase.recarregarDados',
      context: context);

  @override
  Future<void> recarregarDados() {
    return _$recarregarDadosAsyncAction.run(() => super.recarregarDados());
  }

  late final _$_EmergenciaControllerBaseActionController =
      ActionController(name: '_EmergenciaControllerBase', context: context);

  @override
  void selecionarVeterinario(VeterinarioModel veterinario) {
    final _$actionInfo = _$_EmergenciaControllerBaseActionController
        .startAction(name: '_EmergenciaControllerBase.selecionarVeterinario');
    try {
      return super.selecionarVeterinario(veterinario);
    } finally {
      _$_EmergenciaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparSelecao() {
    final _$actionInfo = _$_EmergenciaControllerBaseActionController
        .startAction(name: '_EmergenciaControllerBase.limparSelecao');
    try {
      return super.limparSelecao();
    } finally {
      _$_EmergenciaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
veterinarios: ${veterinarios},
localizacaoAtual: ${localizacaoAtual},
isLoading: ${isLoading},
isLoadingLocation: ${isLoadingLocation},
errorMessage: ${errorMessage},
veterinarioSelecionado: ${veterinarioSelecionado}
    ''';
  }
}

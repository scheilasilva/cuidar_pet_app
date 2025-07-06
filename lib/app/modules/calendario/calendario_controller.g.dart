// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendario_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarioController on _CalendarioControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_CalendarioControllerBase.isFormValid'))
          .value;

  late final _$lembreteAtom =
      Atom(name: '_CalendarioControllerBase.lembrete', context: context);

  @override
  LembreteStore get lembrete {
    _$lembreteAtom.reportRead();
    return super.lembrete;
  }

  @override
  set lembrete(LembreteStore value) {
    _$lembreteAtom.reportWrite(value, super.lembrete, () {
      super.lembrete = value;
    });
  }

  late final _$lembretesAtom =
      Atom(name: '_CalendarioControllerBase.lembretes', context: context);

  @override
  ObservableList<LembreteStore> get lembretes {
    _$lembretesAtom.reportRead();
    return super.lembretes;
  }

  @override
  set lembretes(ObservableList<LembreteStore> value) {
    _$lembretesAtom.reportWrite(value, super.lembretes, () {
      super.lembretes = value;
    });
  }

  late final _$lembretesDataSelecionadaAtom = Atom(
      name: '_CalendarioControllerBase.lembretesDataSelecionada',
      context: context);

  @override
  ObservableList<LembreteStore> get lembretesDataSelecionada {
    _$lembretesDataSelecionadaAtom.reportRead();
    return super.lembretesDataSelecionada;
  }

  @override
  set lembretesDataSelecionada(ObservableList<LembreteStore> value) {
    _$lembretesDataSelecionadaAtom
        .reportWrite(value, super.lembretesDataSelecionada, () {
      super.lembretesDataSelecionada = value;
    });
  }

  late final _$animalSelecionadoIdAtom = Atom(
      name: '_CalendarioControllerBase.animalSelecionadoId', context: context);

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

  late final _$dataSelecionadaAtom =
      Atom(name: '_CalendarioControllerBase.dataSelecionada', context: context);

  @override
  DateTime get dataSelecionada {
    _$dataSelecionadaAtom.reportRead();
    return super.dataSelecionada;
  }

  @override
  set dataSelecionada(DateTime value) {
    _$dataSelecionadaAtom.reportWrite(value, super.dataSelecionada, () {
      super.dataSelecionada = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_CalendarioControllerBase.isLoading', context: context);

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

  late final _$_calendarRebuildTriggerAtom = Atom(
      name: '_CalendarioControllerBase._calendarRebuildTrigger',
      context: context);

  @override
  int get _calendarRebuildTrigger {
    _$_calendarRebuildTriggerAtom.reportRead();
    return super._calendarRebuildTrigger;
  }

  @override
  set _calendarRebuildTrigger(int value) {
    _$_calendarRebuildTriggerAtom
        .reportWrite(value, super._calendarRebuildTrigger, () {
      super._calendarRebuildTrigger = value;
    });
  }

  late final _$loadLembretesByAnimalAsyncAction = AsyncAction(
      '_CalendarioControllerBase.loadLembretesByAnimal',
      context: context);

  @override
  Future<void> loadLembretesByAnimal(String animalId) {
    return _$loadLembretesByAnimalAsyncAction
        .run(() => super.loadLembretesByAnimal(animalId));
  }

  late final _$loadLembretesByDateAsyncAction = AsyncAction(
      '_CalendarioControllerBase.loadLembretesByDate',
      context: context);

  @override
  Future<void> loadLembretesByDate(DateTime data, String animalId) {
    return _$loadLembretesByDateAsyncAction
        .run(() => super.loadLembretesByDate(data, animalId));
  }

  late final _$criarLembreteAsyncAction =
      AsyncAction('_CalendarioControllerBase.criarLembrete', context: context);

  @override
  Future<void> criarLembrete(String titulo, String descricao, DateTime data,
      String categoria, bool concluido) {
    return _$criarLembreteAsyncAction.run(() =>
        super.criarLembrete(titulo, descricao, data, categoria, concluido));
  }

  late final _$marcarComoConcluidoAsyncAction = AsyncAction(
      '_CalendarioControllerBase.marcarComoConcluido',
      context: context);

  @override
  Future<void> marcarComoConcluido(
      LembreteStore lembreteStore, bool concluido) {
    return _$marcarComoConcluidoAsyncAction
        .run(() => super.marcarComoConcluido(lembreteStore, concluido));
  }

  late final _$excluirLembreteAsyncAction = AsyncAction(
      '_CalendarioControllerBase.excluirLembrete',
      context: context);

  @override
  Future<void> excluirLembrete(LembreteStore lembreteParaExcluir) {
    return _$excluirLembreteAsyncAction
        .run(() => super.excluirLembrete(lembreteParaExcluir));
  }

  late final _$_CalendarioControllerBaseActionController =
      ActionController(name: '_CalendarioControllerBase', context: context);

  @override
  void setAnimalSelecionado(String animalId) {
    final _$actionInfo = _$_CalendarioControllerBaseActionController
        .startAction(name: '_CalendarioControllerBase.setAnimalSelecionado');
    try {
      return super.setAnimalSelecionado(animalId);
    } finally {
      _$_CalendarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataSelecionada(DateTime data) {
    final _$actionInfo = _$_CalendarioControllerBaseActionController
        .startAction(name: '_CalendarioControllerBase.setDataSelecionada');
    try {
      return super.setDataSelecionada(data);
    } finally {
      _$_CalendarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_CalendarioControllerBaseActionController
        .startAction(name: '_CalendarioControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_CalendarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
lembrete: ${lembrete},
lembretes: ${lembretes},
lembretesDataSelecionada: ${lembretesDataSelecionada},
animalSelecionadoId: ${animalSelecionadoId},
dataSelecionada: ${dataSelecionada},
isLoading: ${isLoading},
isFormValid: ${isFormValid}
    ''';
  }
}

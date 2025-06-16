// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PerfilController on _PerfilControllerBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_PerfilControllerBase.isFormValid'))
          .value;

  late final _$userAtom =
      Atom(name: '_PerfilControllerBase.user', context: context);

  @override
  UserStore get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserStore value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PerfilControllerBase.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_PerfilControllerBase.errorMessage', context: context);

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

  late final _$loadCurrentUserAsyncAction =
      AsyncAction('_PerfilControllerBase.loadCurrentUser', context: context);

  @override
  Future<void> loadCurrentUser() {
    return _$loadCurrentUserAsyncAction.run(() => super.loadCurrentUser());
  }

  late final _$salvarPerfilAsyncAction =
      AsyncAction('_PerfilControllerBase.salvarPerfil', context: context);

  @override
  Future<void> salvarPerfil() {
    return _$salvarPerfilAsyncAction.run(() => super.salvarPerfil());
  }

  late final _$atualizarPerfilComImagemAsyncAction = AsyncAction(
      '_PerfilControllerBase.atualizarPerfilComImagem',
      context: context);

  @override
  Future<void> atualizarPerfilComImagem(String imagePath) {
    return _$atualizarPerfilComImagemAsyncAction
        .run(() => super.atualizarPerfilComImagem(imagePath));
  }

  late final _$alterarSenhaAsyncAction =
      AsyncAction('_PerfilControllerBase.alterarSenha', context: context);

  @override
  Future<void> alterarSenha(String senhaAtual, String novaSenha) {
    return _$alterarSenhaAsyncAction
        .run(() => super.alterarSenha(senhaAtual, novaSenha));
  }

  late final _$excluirContaAsyncAction =
      AsyncAction('_PerfilControllerBase.excluirConta', context: context);

  @override
  Future<void> excluirConta() {
    return _$excluirContaAsyncAction.run(() => super.excluirConta());
  }

  late final _$_PerfilControllerBaseActionController =
      ActionController(name: '_PerfilControllerBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_PerfilControllerBaseActionController.startAction(
        name: '_PerfilControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_PerfilControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_PerfilControllerBaseActionController.startAction(
        name: '_PerfilControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_PerfilControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isFormValid: ${isFormValid}
    ''';
  }
}

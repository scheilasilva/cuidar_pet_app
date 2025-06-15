// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autenticacao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AutenticacaoController on _AutenticacaoControllerBase, Store {
  late final _$isLoginAtom =
      Atom(name: '_AutenticacaoControllerBase.isLogin', context: context);

  @override
  bool get isLogin {
    _$isLoginAtom.reportRead();
    return super.isLogin;
  }

  @override
  set isLogin(bool value) {
    _$isLoginAtom.reportWrite(value, super.isLogin, () {
      super.isLogin = value;
    });
  }

  late final _$obscurePasswordAtom = Atom(
      name: '_AutenticacaoControllerBase.obscurePassword', context: context);

  @override
  bool get obscurePassword {
    _$obscurePasswordAtom.reportRead();
    return super.obscurePassword;
  }

  @override
  set obscurePassword(bool value) {
    _$obscurePasswordAtom.reportWrite(value, super.obscurePassword, () {
      super.obscurePassword = value;
    });
  }

  late final _$obscureConfirmPasswordAtom = Atom(
      name: '_AutenticacaoControllerBase.obscureConfirmPassword',
      context: context);

  @override
  bool get obscureConfirmPassword {
    _$obscureConfirmPasswordAtom.reportRead();
    return super.obscureConfirmPassword;
  }

  @override
  set obscureConfirmPassword(bool value) {
    _$obscureConfirmPasswordAtom
        .reportWrite(value, super.obscureConfirmPassword, () {
      super.obscureConfirmPassword = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AutenticacaoControllerBase.isLoading', context: context);

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
      Atom(name: '_AutenticacaoControllerBase.errorMessage', context: context);

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

  late final _$loginAsyncAction =
      AsyncAction('_AutenticacaoControllerBase.login', context: context);

  @override
  Future<void> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$registerAsyncAction =
      AsyncAction('_AutenticacaoControllerBase.register', context: context);

  @override
  Future<void> register(
      String name, String email, String password, String confirmPassword) {
    return _$registerAsyncAction
        .run(() => super.register(name, email, password, confirmPassword));
  }

  late final _$signInWithGoogleAsyncAction = AsyncAction(
      '_AutenticacaoControllerBase.signInWithGoogle',
      context: context);

  @override
  Future<void> signInWithGoogle() {
    return _$signInWithGoogleAsyncAction.run(() => super.signInWithGoogle());
  }

  late final _$resetPasswordAsyncAction = AsyncAction(
      '_AutenticacaoControllerBase.resetPassword',
      context: context);

  @override
  Future<void> resetPassword(String email) {
    return _$resetPasswordAsyncAction.run(() => super.resetPassword(email));
  }

  late final _$_AutenticacaoControllerBaseActionController =
      ActionController(name: '_AutenticacaoControllerBase', context: context);

  @override
  void toggleAuthMode() {
    final _$actionInfo = _$_AutenticacaoControllerBaseActionController
        .startAction(name: '_AutenticacaoControllerBase.toggleAuthMode');
    try {
      return super.toggleAuthMode();
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo =
        _$_AutenticacaoControllerBaseActionController.startAction(
            name: '_AutenticacaoControllerBase.togglePasswordVisibility');
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleConfirmPasswordVisibility() {
    final _$actionInfo =
        _$_AutenticacaoControllerBaseActionController.startAction(
            name:
                '_AutenticacaoControllerBase.toggleConfirmPasswordVisibility');
    try {
      return super.toggleConfirmPasswordVisibility();
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_AutenticacaoControllerBaseActionController
        .startAction(name: '_AutenticacaoControllerBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_AutenticacaoControllerBaseActionController
        .startAction(name: '_AutenticacaoControllerBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AutenticacaoControllerBaseActionController
        .startAction(name: '_AutenticacaoControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AutenticacaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLogin: ${isLogin},
obscurePassword: ${obscurePassword},
obscureConfirmPassword: ${obscureConfirmPassword},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}

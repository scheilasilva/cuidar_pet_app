// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashController on _SplashControllerBase, Store {
  late final _$_opacityAtom =
      Atom(name: '_SplashControllerBase._opacity', context: context);

  @override
  double get _opacity {
    _$_opacityAtom.reportRead();
    return super._opacity;
  }

  @override
  set _opacity(double value) {
    _$_opacityAtom.reportWrite(value, super._opacity, () {
      super._opacity = value;
    });
  }

  late final _$_SplashControllerBaseActionController =
      ActionController(name: '_SplashControllerBase', context: context);

  @override
  void _setOpacity(double value) {
    final _$actionInfo = _$_SplashControllerBaseActionController.startAction(
        name: '_SplashControllerBase._setOpacity');
    try {
      return super._setOpacity(value);
    } finally {
      _$_SplashControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fadeInLogo() {
    final _$actionInfo = _$_SplashControllerBaseActionController.startAction(
        name: '_SplashControllerBase.fadeInLogo');
    try {
      return super.fadeInLogo();
    } finally {
      _$_SplashControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fadeOutLogo() {
    final _$actionInfo = _$_SplashControllerBaseActionController.startAction(
        name: '_SplashControllerBase.fadeOutLogo');
    try {
      return super.fadeOutLogo();
    } finally {
      _$_SplashControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  @observable
  double _opacity = 0.0;

  double get opacity => _opacity;

  @action
  void _setOpacity(double value) {
    _opacity = value;
  }

  Future<void> load(BuildContext context) async {
    // Iniciar fade in do logo
    fadeInLogo();

    // Aguardar um tempo para mostrar a animação
    await Future.delayed(const Duration(milliseconds: 2500));

    // Verificar autenticação e navegar
    await _checkAuthAndNavigate();
  }

  @action
  void fadeInLogo() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _setOpacity(1.0);
    });
  }

  @action
  void fadeOutLogo() {
    _setOpacity(0.0);
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Fade out do logo antes de navegar
      fadeOutLogo();
      await Future.delayed(const Duration(milliseconds: 500));

      // Buscar o AuthService via Modular.get
      final AuthService authService = Modular.get<AuthService>();

      // Verifica se o usuário está logado
      final user = authService.currentUser;

      if (user != null) {
        // Usuário está logado, vai para a home
        Modular.to.navigate('/$homeRoute');
      } else {
        // Usuário não está logado, vai para autenticação
        Modular.to.navigate('/$autenticacaoRoute');
      }
    } catch (e) {
      print('Erro no checkAuthStatus: $e');
      // Em caso de erro, vai para autenticação
      Modular.to.navigate('/$autenticacaoRoute');
    }
  }
}
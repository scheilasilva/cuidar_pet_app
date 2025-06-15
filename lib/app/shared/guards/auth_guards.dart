import 'dart:async';

import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/services/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ModularRoute route) {
    try {
      final AuthService authService = Modular.get<AuthService>();

      final isAuthenticated = authService.currentUser != null;

      if (!isAuthenticated) {
        Modular.to.navigate('/$autenticacaoRoute');
        return false;
      }

      return true;
    } catch (e) {
      Modular.to.navigate('/$autenticacaoRoute');
      return false;
    }
  }
}

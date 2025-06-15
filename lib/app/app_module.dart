import 'package:cuidar_pet_app/app/modules/animal/cadastro_animal_module.dart';
import 'package:cuidar_pet_app/app/modules/autenticacao/autenticacao_module.dart';
import 'package:cuidar_pet_app/app/modules/home/home_module.dart';
import 'package:cuidar_pet_app/app/modules/splash/splash_module.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/services/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<AuthService>(AuthService.new);
  }

  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: SplashModule());

    r.module('/$autenticacaoRoute', module: AutenticacaoModule());

    r.module('/$homeRoute', module: HomeModule());


    super.routes(r);
  }
}
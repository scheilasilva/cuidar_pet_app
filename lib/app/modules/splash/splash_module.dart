import 'package:cuidar_pet_app/app/modules/splash/splash_controller.dart';
import 'package:cuidar_pet_app/app/modules/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<SplashController>(SplashController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
  }
}
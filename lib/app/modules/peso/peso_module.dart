import 'package:cuidar_pet_app/app/modules/peso/peso_controller.dart';
import 'package:cuidar_pet_app/app/modules/peso/peso_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/peso_repository.dart';
import 'repositories/peso_repository_interface.dart';
import 'services/peso_service.dart';
import 'services/peso_service_interface.dart';

class PesoModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IPesoRepository>(() => PesoRepository());

    // Service
    i.addSingleton<IPesoService>(() => PesoService(i.get<IPesoRepository>()));

    // Controller
    i.addSingleton<PesoController>(() => PesoController(i.get<IPesoService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const PesoPage(),
    );
  }
}

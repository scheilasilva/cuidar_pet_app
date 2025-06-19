import 'package:cuidar_pet_app/app/modules/emergencia/emergencia_controller.dart';
import 'package:cuidar_pet_app/app/modules/emergencia/emergencia_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'services/emergencia_service.dart';
import 'services/emergencia_service_interface.dart';

class EmergenciaModule extends Module {
  @override
  void binds(Injector i) {
    // Service
    i.addSingleton<IEmergenciaService>(() => EmergenciaService());

    // Controller
    i.addSingleton<EmergenciaController>(() => EmergenciaController(i.get<IEmergenciaService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const EmergenciaPage(),
    );
  }
}

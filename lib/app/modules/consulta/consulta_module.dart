import 'package:cuidar_pet_app/app/modules/consulta/consulta_controller.dart';
import 'package:cuidar_pet_app/app/modules/consulta/consulta_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/consulta_repository.dart';
import 'repositories/consulta_repository_interface.dart';
import 'services/consulta_service.dart';
import 'services/consulta_service_interface.dart';

class ConsultaModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IConsultaRepository>(() => ConsultaRepository());

    // Service
    i.addSingleton<IConsultaService>(() => ConsultaService(i.get<IConsultaRepository>()));

    // Controller
    i.addSingleton<ConsultaController>(() => ConsultaController(i.get<IConsultaService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const ConsultaPage(),
    );
  }
}

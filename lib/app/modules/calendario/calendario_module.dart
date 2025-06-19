import 'package:cuidar_pet_app/app/modules/calendario/calendario_controller.dart';
import 'package:cuidar_pet_app/app/modules/calendario/calendario_page.dart';
import 'package:cuidar_pet_app/app/modules/calendario/lembrete/repositories/lembrete_repository.dart';
import 'package:cuidar_pet_app/app/modules/calendario/lembrete/repositories/lembrete_repository_interface.dart';
import 'package:cuidar_pet_app/app/modules/calendario/lembrete/services/lembrete_service.dart';
import 'package:cuidar_pet_app/app/modules/calendario/lembrete/services/lembrete_service_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CalendarioModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<ILembreteRepository>(() => LembreteRepository());

    // Service
    i.addSingleton<ILembreteService>(() => LembreteService(i.get<ILembreteRepository>()));

    // Controller
    i.addSingleton<CalendarioController>(() => CalendarioController(i.get<ILembreteService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const CalendarioPage(),
    );
  }
}

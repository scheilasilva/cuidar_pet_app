import 'package:cuidar_pet_app/app/modules/exame/exame_controller.dart';
import 'package:cuidar_pet_app/app/modules/exame/exame_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/exame_repository.dart';
import 'repositories/exame_repository_interface.dart';
import 'services/exame_service.dart';
import 'services/exame_service_interface.dart';

class ExameModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IExameRepository>(() => ExameRepository());

    // Service
    i.addSingleton<IExameService>(() => ExameService(i.get<IExameRepository>()));

    // Controller
    i.addSingleton<ExameController>(() => ExameController(i.get<IExameService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const ExamePage(),
    );
  }
}

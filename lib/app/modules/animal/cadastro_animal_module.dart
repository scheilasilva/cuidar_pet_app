import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/animal/cadastro_animal_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/animal_repository.dart';
import 'repositories/animal_repository_interface.dart';
import 'services/animal_service.dart';
import 'services/animal_service_interface.dart';

class AnimalModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IAnimalRepository>(() => AnimalRepository());

    // Service
    i.addSingleton<IAnimalService>(() => AnimalService(i.get<IAnimalRepository>()));

    // Controller
    i.addSingleton<AnimalController>(() => AnimalController(i.get<IAnimalService>()));
  }

  @override
  void routes(RouteManager r) {
    // Mudança aqui: usar Modular.initialRoute em vez de '/cadastro'
    r.child(
      Modular.initialRoute,
      child: (context) => const CadastroAnimalPage(),
    );
  }
}
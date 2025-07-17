import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/animal/cadastro_animal_page.dart';
import 'package:cuidar_pet_app/app/modules/peso/services/peso_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/peso/services/peso_service.dart'; // ADICIONAR
import 'package:cuidar_pet_app/app/modules/peso/repositories/peso_repository.dart'; // ADICIONAR
import 'package:cuidar_pet_app/app/modules/peso/repositories/peso_repository_interface.dart'; // ADICIONAR
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

    // ADICIONAR: Binds do módulo de peso
    i.addSingleton<IPesoRepository>(() => PesoRepository());
    i.addSingleton<IPesoService>(() => PesoService(i.get<IPesoRepository>()));

    // Controller
    i.addSingleton<AnimalController>(() => AnimalController(
        i.get<IAnimalService>(),
        i.get<IPesoService>()
    ));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const CadastroAnimalPage(),
    );
  }
}

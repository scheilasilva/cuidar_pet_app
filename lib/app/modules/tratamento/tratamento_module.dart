import 'package:cuidar_pet_app/app/modules/tratamento/tratamento_controller.dart';
import 'package:cuidar_pet_app/app/modules/tratamento/tratamento_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/tratamento_repository.dart';
import 'repositories/tratamento_repository_interface.dart';
import 'services/tratamento_service.dart';
import 'services/tratamento_service_interface.dart';

class TratamentoModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<ITratamentoRepository>(() => TratamentoRepository());

    // Service
    i.addSingleton<ITratamentoService>(() => TratamentoService(i.get<ITratamentoRepository>()));

    // Controller
    i.addSingleton<TratamentoController>(() => TratamentoController(i.get<ITratamentoService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const TratamentoPage(),
    );
  }
}
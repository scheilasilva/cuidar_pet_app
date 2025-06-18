import 'package:cuidar_pet_app/app/modules/alimentacao/alimentacao_controller.dart';
import 'package:cuidar_pet_app/app/modules/alimentacao/alimentacao_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/alimentacao_repository.dart';
import 'repositories/alimentacao_repository_interface.dart';
import 'services/alimentacao_service.dart';
import 'services/alimentacao_service_interface.dart';

class AlimentacaoModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IAlimentacaoRepository>(() => AlimentacaoRepository());

    // Service
    i.addSingleton<IAlimentacaoService>(() => AlimentacaoService(i.get<IAlimentacaoRepository>()));

    // Controller
    i.addSingleton<AlimentacaoController>(() => AlimentacaoController(i.get<IAlimentacaoService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const AlimentacaoPage(),
    );
  }
}

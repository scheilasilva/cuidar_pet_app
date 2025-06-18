import 'package:cuidar_pet_app/app/modules/vacinacao/vacinacao_controller.dart';
import 'package:cuidar_pet_app/app/modules/vacinacao/vacinacao_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/vacinacao_repository.dart';
import 'repositories/vacinacao_repository_interface.dart';
import 'services/vacinacao_service.dart';
import 'services/vacinacao_service_interface.dart';

class VacinacaoModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<IVacinacaoRepository>(() => VacinacaoRepository());

    // Service
    i.addSingleton<IVacinacaoService>(() => VacinacaoService(i.get<IVacinacaoRepository>()));

    // Controller
    i.addSingleton<VacinacaoController>(() => VacinacaoController(i.get<IVacinacaoService>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const VacinacaoPage(),
    );
  }
}

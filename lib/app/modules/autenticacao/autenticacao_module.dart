import 'package:cuidar_pet_app/app/modules/autenticacao/autenticacao_controller.dart';
import 'package:cuidar_pet_app/app/modules/autenticacao/autenticacao_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AutenticacaoModule extends Module {
  @override
  void binds(Injector i) {
    i.add<AutenticacaoController>(AutenticacaoController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AutenticacaoPage());
    super.routes(r);
  }
}

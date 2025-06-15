import 'package:cuidar_pet_app/app/modules/vacinacao/vacinacao_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VacinacaoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const VacinacaoPage());

  }
}

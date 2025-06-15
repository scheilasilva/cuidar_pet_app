import 'package:cuidar_pet_app/app/modules/alimentacao/alimentacao_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AlimentacaoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AlimentacaoPage());

  }
}

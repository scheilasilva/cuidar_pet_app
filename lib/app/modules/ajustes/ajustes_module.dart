import 'package:cuidar_pet_app/app/modules/ajustes/ajustes_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AjustesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AjustesPage());

    super.routes(r);
  }
}

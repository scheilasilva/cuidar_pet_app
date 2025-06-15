import 'package:cuidar_pet_app/app/modules/peso/peso_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

  class PesoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const PesoPage());

  }
}

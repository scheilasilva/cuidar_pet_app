import 'package:cuidar_pet_app/app/modules/calendario/calendario_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CalendarioModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const CalendarioPage());

  }
}

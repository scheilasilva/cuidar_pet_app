import 'package:cuidar_pet_app/app/modules/consulta/consulta_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ConsultaModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ConsultaPage());

  }
}

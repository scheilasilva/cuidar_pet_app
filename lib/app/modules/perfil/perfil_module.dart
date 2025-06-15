import 'package:cuidar_pet_app/app/modules/perfil/perfil_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PerfilModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const PerfilPage());

    super.routes(r);
  }
}
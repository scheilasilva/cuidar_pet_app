import 'package:cuidar_pet_app/app/modules/notificacoes/notificacoes_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificacoesModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const NotificacoesPage());

    super.routes(r);
  }
}
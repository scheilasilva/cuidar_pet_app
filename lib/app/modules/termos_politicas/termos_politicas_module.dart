import 'package:cuidar_pet_app/app/modules/termos_politicas/termos_politicas_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TermosPoliticaModule extends Module {

  void routes(RouteManager r){
    r.child(Modular.initialRoute, child: (contexto) => const TermosPoliticasPage());
  }

}
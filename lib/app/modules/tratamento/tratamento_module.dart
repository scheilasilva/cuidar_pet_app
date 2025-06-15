import 'package:cuidar_pet_app/app/modules/tratamento/tratamento_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TratamentoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const TratamentoPage());

  }
}

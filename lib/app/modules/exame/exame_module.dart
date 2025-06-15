import 'package:cuidar_pet_app/app/modules/exame/exame_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExameModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ExamePage());

  }
}

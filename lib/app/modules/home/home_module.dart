import 'package:cuidar_pet_app/app/modules/ajustes/ajustes_module.dart';
import 'package:cuidar_pet_app/app/modules/alimentacao/alimentacao_module.dart';
import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/animal/cadastro_animal_module.dart';
import 'package:cuidar_pet_app/app/modules/animal/repositories/animal_repository.dart';
import 'package:cuidar_pet_app/app/modules/animal/repositories/animal_repository_interface.dart';
import 'package:cuidar_pet_app/app/modules/animal/services/animal_service.dart';
import 'package:cuidar_pet_app/app/modules/animal/services/animal_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/calendario/calendario_module.dart';
import 'package:cuidar_pet_app/app/modules/consulta/consulta_module.dart';
import 'package:cuidar_pet_app/app/modules/emergencia/emergencia_module.dart';
import 'package:cuidar_pet_app/app/modules/exame/exame_module.dart';
import 'package:cuidar_pet_app/app/modules/home/home_page.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/notificacoes_module.dart';
import 'package:cuidar_pet_app/app/modules/perfil/perfil_module.dart';
import 'package:cuidar_pet_app/app/modules/peso/peso_module.dart';
import 'package:cuidar_pet_app/app/modules/tratamento/tratamento_module.dart';
import 'package:cuidar_pet_app/app/modules/vacinacao/vacinacao_module.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    // Binds do módulo de animais
    i.addSingleton<IAnimalRepository>(() => AnimalRepository());
    i.addSingleton<IAnimalService>(() => AnimalService(i.get<IAnimalRepository>()));
    i.addSingleton<AnimalController>(() => AnimalController(i.get<IAnimalService>()));
  }
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const HomePage());

    r.module('/$notificacoesRoute', module: NotificacoesModule());
    r.module('/$ajustesRoute', module: AjustesModule());
    r.module('/$perfilRoute', module: PerfilModule());
    r.module('/$exameRoute', module: ExameModule());
    r.module('/$consultaRoute', module: ConsultaModule());
    r.module('/$alimentacaoRoute', module: AlimentacaoModule());
    r.module('/$tratamentoRoute', module: TratamentoModule());
    r.module('/$vacinacaoRoute', module: VacinacaoModule());
    r.module('/$calendarioRoute', module: CalendarioModule());
    r.module('/$pesoRoute', module: PesoModule());
    r.module('/$cadastroAnimalRoute', module: AnimalModule());
    r.module('/$emergenciaRoute', module: EmergenciaModule());
  }
}

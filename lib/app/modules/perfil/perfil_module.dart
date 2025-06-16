import 'package:cuidar_pet_app/app/modules/perfil/perfil_controller.dart';
import 'package:cuidar_pet_app/app/modules/perfil/perfil_page.dart';
import 'package:cuidar_pet_app/app/modules/user/repositories/user_repository.dart';
import 'package:cuidar_pet_app/app/modules/user/repositories/user_repository_interface.dart';
import 'package:cuidar_pet_app/app/modules/user/services/user_service.dart';
import 'package:cuidar_pet_app/app/modules/user/services/user_service_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PerfilModule extends Module {
  @override
  void binds(Injector i) {
    i.add<PerfilController>(PerfilController.new);
    i.add<IUserService>(UserService.new);
    i.add<IUserRepository>(UserRepository.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const PerfilPage());

    super.routes(r);
  }
}
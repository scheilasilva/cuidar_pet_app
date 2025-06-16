import 'package:mobx/mobx.dart';
import '../models/user_model.dart';

part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class UserStoreFactory {
  static UserStore fromModel(UserModel model) => UserStore(
    id: model.id,
    nome: model.nome,
    email: model.email,
    imagem: model.imagem,
  );

  static UserStore novo() => UserStore(
    id: '',
    nome: '',
    email: '',
    imagem: null,
  );
}

abstract class _UserStoreBase with Store {
  @observable
  String id;

  @observable
  String nome;

  @observable
  String email;

  @observable
  String? imagem;

  _UserStoreBase({
    required this.id,
    required this.nome,
    required this.email,
    this.imagem,
  });

  UserModel toModel() {
    return UserModel(
      id: id,
      nome: nome,
      email: email,
      imagem: imagem,
    );
  }
}

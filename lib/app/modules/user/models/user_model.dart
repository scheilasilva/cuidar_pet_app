class UserModel {
  String id;
  String nome;
  String email;
  String? imagem;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.imagem,
  });
}

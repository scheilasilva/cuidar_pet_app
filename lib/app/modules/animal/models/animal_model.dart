class AnimalModel {
  String id;
  String nome;
  String? imagem;
  String tipoAnimal;
  int idade;
  String genero;
  double peso;

  AnimalModel({
    required this.id,
    required this.nome,
    this.imagem,
    required this.tipoAnimal,
    required this.idade,
    required this.genero,
    required this.peso,
  });
}
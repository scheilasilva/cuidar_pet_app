class ExameModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String descricao;
  String dataRealizacao;
  String tipo;
  String? imagem;
  DateTime createdAt;

  ExameModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataRealizacao,
    required this.tipo,
    this.imagem,
    required this.createdAt,
  });
}

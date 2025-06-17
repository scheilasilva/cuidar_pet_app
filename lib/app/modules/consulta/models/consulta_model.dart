class ConsultaModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String descricao;
  String dataConsulta;
  String tipo;
  String? imagem;
  DateTime createdAt;

  ConsultaModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataConsulta,
    required this.tipo,
    this.imagem,
    required this.createdAt,
  });
}

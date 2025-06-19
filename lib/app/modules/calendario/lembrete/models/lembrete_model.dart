class LembreteModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String descricao;
  DateTime dataLembrete;
  String categoria;
  bool concluido;
  DateTime createdAt;

  LembreteModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataLembrete,
    required this.categoria,
    this.concluido = false,
    required this.createdAt,
  });
}

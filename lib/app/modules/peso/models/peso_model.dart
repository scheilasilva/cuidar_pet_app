class PesoModel {
  String id;
  String animalId; // Referência ao animal
  double peso;
  DateTime dataPesagem;
  String? observacao;
  DateTime createdAt;

  PesoModel({
    required this.id,
    required this.animalId,
    required this.peso,
    required this.dataPesagem,
    this.observacao,
    required this.createdAt,
  });
}

class TratamentoModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String descricao;
  String dataInicio;
  String tipo;
  String? imagem;
  bool concluido; // NOVO: campo para controlar se está concluído
  DateTime createdAt;

  TratamentoModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataInicio,
    required this.tipo,
    this.imagem,
    this.concluido = false, // Por padrão não está concluído
    required this.createdAt,
  });
}
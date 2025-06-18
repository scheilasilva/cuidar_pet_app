class VacinacaoModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String descricao;
  String dataVacinacao;
  String tipo;
  String? imagem;
  bool concluida; // Para marcar como concluída
  DateTime createdAt;

  VacinacaoModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataVacinacao,
    required this.tipo,
    this.imagem,
    this.concluida = false, // Por padrão não está concluída
    required this.createdAt,
  });
}

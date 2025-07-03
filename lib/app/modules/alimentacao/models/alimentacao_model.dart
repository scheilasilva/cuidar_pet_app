import 'package:uuid/uuid.dart';

class AlimentacaoModel {
  String id;
  String animalId; // Referência ao animal
  String titulo;
  String horario;
  String alimento;
  String observacao;
  DateTime createdAt;

  AlimentacaoModel({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.horario,
    required this.alimento,
    required this.observacao,
    required this.createdAt,
  });

  // Método para garantir que o ID seja gerado se estiver vazio
  void ensureId() {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}

class NotificacoesModel {
  String id;
  String type; // 'alimentacao', 'vacinacao', 'exame', 'tratamento'
  String title;
  String body;
  DateTime scheduledTime;
  DateTime? sentTime; // null se ainda não foi enviada
  String relatedId; // ID da alimentação, vacinação, etc.
  String animalId;
  bool isRead;
  DateTime createdAt;

  NotificacoesModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.sentTime,
    required this.relatedId,
    required this.animalId,
    this.isRead = false,
    required this.createdAt,
  });
}

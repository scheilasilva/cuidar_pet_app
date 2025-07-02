import 'package:cuidar_pet_app/app/modules/notificacoes/models/notificacoes_model.dart' show NotificacoesModel;
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class NotificacoesRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'notificacoes';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        scheduled_time INTEGER NOT NULL,
        sent_time INTEGER,
        related_id TEXT NOT NULL,
        animal_id TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      );
    ''');
  }

  Future<List<NotificacoesModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  Future<List<NotificacoesModel>> getSentNotificacoes() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'sent_time IS NOT NULL',
      orderBy: 'sent_time DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  Future<List<NotificacoesModel>> getScheduledNotificacoes() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'sent_time IS NULL AND scheduled_time > ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
      orderBy: 'scheduled_time ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  Future<void> save(NotificacoesModel notificacao) async {
    final db = await _databaseLocal.getDb();

    if (notificacao.id.isEmpty) {
      notificacao.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(notificacao),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markAsSent(String id) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      {'sent_time': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAsRead(String id) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _databaseLocal.getDb();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteByRelatedId(String relatedId) async {
    final db = await _databaseLocal.getDb();
    await db.delete(
      _tableName,
      where: 'related_id = ?',
      whereArgs: [relatedId],
    );
  }

  NotificacoesModel _fromMap(Map<String, dynamic> map) {
    return NotificacoesModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(map['scheduled_time'] ?? 0),
      sentTime: map['sent_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sent_time'])
          : null,
      relatedId: map['related_id'] ?? '',
      animalId: map['animal_id'] ?? '',
      isRead: (map['is_read'] ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(NotificacoesModel notificacao) {
    return {
      'id': notificacao.id,
      'type': notificacao.type,
      'title': notificacao.title,
      'body': notificacao.body,
      'scheduled_time': notificacao.scheduledTime.millisecondsSinceEpoch,
      'sent_time': notificacao.sentTime?.millisecondsSinceEpoch,
      'related_id': notificacao.relatedId,
      'animal_id': notificacao.animalId,
      'is_read': notificacao.isRead ? 1 : 0,
      'created_at': notificacao.createdAt.millisecondsSinceEpoch,
    };
  }
}

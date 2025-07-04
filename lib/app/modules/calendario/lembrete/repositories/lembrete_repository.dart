import 'package:cuidar_pet_app/app/modules/calendario/lembrete/repositories/lembrete_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/lembrete_model.dart';

class LembreteRepository implements ILembreteRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'lembretes';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_lembrete INTEGER NOT NULL,
        categoria TEXT NOT NULL,
        concluido INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<LembreteModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'data_lembrete ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<LembreteModel>> getByAnimalId(String animalId) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'data_lembrete ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<LembreteModel>> getByDate(DateTime date, String animalId) async {
    final db = await _databaseLocal.getDb();

    // Normalizar a data para o horário local sem considerar fuso horário
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Início e fim do dia em horário local
    final startOfDay = DateTime(normalizedDate.year, normalizedDate.month, normalizedDate.day, 0, 0, 0);
    final endOfDay = DateTime(normalizedDate.year, normalizedDate.month, normalizedDate.day, 23, 59, 59, 999);

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ? AND data_lembrete >= ? AND data_lembrete <= ?',
      whereArgs: [
        animalId,
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
      orderBy: 'data_lembrete ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<LembreteModel?> getById(String id) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> save(LembreteModel lembrete) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (lembrete.id.isEmpty) {
      lembrete.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(lembrete),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(LembreteModel lembrete) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(lembrete),
      where: 'id = ?',
      whereArgs: [lembrete.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _databaseLocal.getDb();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  LembreteModel _fromMap(Map<String, dynamic> map) {
    return LembreteModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      // Garantir que a data seja interpretada no horário local
      dataLembrete: DateTime.fromMillisecondsSinceEpoch(map['data_lembrete'] ?? 0, isUtc: false),
      categoria: map['categoria'] ?? '',
      concluido: (map['concluido'] ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0, isUtc: false),
    );
  }

  Map<String, dynamic> _toMap(LembreteModel lembrete) {
    // Normalizar a data do lembrete para garantir que seja salva corretamente
    final normalizedDataLembrete = DateTime(
      lembrete.dataLembrete.year,
      lembrete.dataLembrete.month,
      lembrete.dataLembrete.day,
      12, // Definir meio-dia para evitar problemas de fuso horário
      0,
      0,
    );

    return {
      'id': lembrete.id,
      'animal_id': lembrete.animalId,
      'titulo': lembrete.titulo,
      'descricao': lembrete.descricao,
      'data_lembrete': normalizedDataLembrete.millisecondsSinceEpoch,
      'categoria': lembrete.categoria,
      'concluido': lembrete.concluido ? 1 : 0,
      'created_at': lembrete.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

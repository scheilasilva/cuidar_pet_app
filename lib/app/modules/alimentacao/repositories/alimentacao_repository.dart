import 'package:cuidar_pet_app/app/modules/alimentacao/repositories/alimentacao_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/alimentacao_model.dart';

class AlimentacaoRepository implements IAlimentacaoRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'alimentacoes';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        horario TEXT NOT NULL,
        alimento TEXT NOT NULL,
        observacao TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<AlimentacaoModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<AlimentacaoModel>> getByAnimalId(String animalId) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<AlimentacaoModel?> getById(String id) async {
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
  Future<void> save(AlimentacaoModel alimentacao) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (alimentacao.id.isEmpty) {
      alimentacao.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(alimentacao),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(AlimentacaoModel alimentacao) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(alimentacao),
      where: 'id = ?',
      whereArgs: [alimentacao.id],
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

  AlimentacaoModel _fromMap(Map<String, dynamic> map) {
    return AlimentacaoModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      horario: map['horario'] ?? '',
      alimento: map['alimento'] ?? '',
      observacao: map['observacao'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(AlimentacaoModel alimentacao) {
    return {
      'id': alimentacao.id,
      'animal_id': alimentacao.animalId,
      'titulo': alimentacao.titulo,
      'horario': alimentacao.horario,
      'alimento': alimentacao.alimento,
      'observacao': alimentacao.observacao,
      'created_at': alimentacao.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

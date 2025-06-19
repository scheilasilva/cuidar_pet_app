import 'package:cuidar_pet_app/app/modules/peso/repositories/peso_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/peso_model.dart';

class PesoRepository implements IPesoRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'pesos';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        peso REAL NOT NULL,
        data_pesagem INTEGER NOT NULL,
        observacao TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<PesoModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'data_pesagem DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<PesoModel>> getByAnimalId(String animalId) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'data_pesagem DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<PesoModel?> getById(String id) async {
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
  Future<PesoModel?> getUltimoPesoByAnimalId(String animalId) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'data_pesagem DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> save(PesoModel peso) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (peso.id.isEmpty) {
      peso.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(peso),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(PesoModel peso) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(peso),
      where: 'id = ?',
      whereArgs: [peso.id],
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

  PesoModel _fromMap(Map<String, dynamic> map) {
    return PesoModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      peso: (map['peso'] ?? 0.0).toDouble(),
      dataPesagem: DateTime.fromMillisecondsSinceEpoch(map['data_pesagem'] ?? 0),
      observacao: map['observacao'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(PesoModel peso) {
    return {
      'id': peso.id,
      'animal_id': peso.animalId,
      'peso': peso.peso,
      'data_pesagem': peso.dataPesagem.millisecondsSinceEpoch,
      'observacao': peso.observacao,
      'created_at': peso.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

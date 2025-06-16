import 'package:cuidar_pet_app/app/modules/exame/repositories/exame_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/exame_model.dart';

class ExameRepository implements IExameRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'exames';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_realizacao TEXT NOT NULL,
        tipo TEXT NOT NULL,
        imagem TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<ExameModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<ExameModel>> getByAnimalId(String animalId) async {
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
  Future<ExameModel?> getById(String id) async {
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
  Future<void> save(ExameModel exame) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (exame.id.isEmpty) {
      exame.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(exame),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(ExameModel exame) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(exame),
      where: 'id = ?',
      whereArgs: [exame.id],
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

  ExameModel _fromMap(Map<String, dynamic> map) {
    return ExameModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataRealizacao: map['data_realizacao'] ?? '',
      tipo: map['tipo'] ?? '',
      imagem: map['imagem'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(ExameModel exame) {
    return {
      'id': exame.id,
      'animal_id': exame.animalId,
      'titulo': exame.titulo,
      'descricao': exame.descricao,
      'data_realizacao': exame.dataRealizacao,
      'tipo': exame.tipo,
      'imagem': exame.imagem,
      'created_at': exame.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

import 'package:cuidar_pet_app/app/modules/tratamento/repositories/tratamento_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/tratamento_model.dart';

class TratamentoRepository implements ITratamentoRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'tratamentos';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_inicio TEXT NOT NULL,
        tipo TEXT NOT NULL,
        imagem TEXT,
        concluido INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<TratamentoModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<TratamentoModel>> getByAnimalId(String animalId) async {
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
  Future<List<TratamentoModel>> getByAnimalIdAndStatus(String animalId, bool concluido) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ? AND concluido = ?',
      whereArgs: [animalId, concluido ? 1 : 0],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<TratamentoModel?> getById(String id) async {
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
  Future<void> save(TratamentoModel tratamento) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (tratamento.id.isEmpty) {
      tratamento.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(tratamento),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(TratamentoModel tratamento) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(tratamento),
      where: 'id = ?',
      whereArgs: [tratamento.id],
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

  TratamentoModel _fromMap(Map<String, dynamic> map) {
    return TratamentoModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataInicio: map['data_inicio'] ?? '',
      tipo: map['tipo'] ?? '',
      imagem: map['imagem'],
      concluido: (map['concluido'] ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(TratamentoModel tratamento) {
    return {
      'id': tratamento.id,
      'animal_id': tratamento.animalId,
      'titulo': tratamento.titulo,
      'descricao': tratamento.descricao,
      'data_inicio': tratamento.dataInicio,
      'tipo': tratamento.tipo,
      'imagem': tratamento.imagem,
      'concluido': tratamento.concluido ? 1 : 0,
      'created_at': tratamento.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}
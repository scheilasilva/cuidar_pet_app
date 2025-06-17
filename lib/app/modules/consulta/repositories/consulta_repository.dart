import 'package:cuidar_pet_app/app/modules/consulta/repositories/consulta_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/consulta_model.dart';

class ConsultaRepository implements IConsultaRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'consultas';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_consulta TEXT NOT NULL,
        tipo TEXT NOT NULL,
        imagem TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<ConsultaModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<ConsultaModel>> getByAnimalId(String animalId) async {
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
  Future<ConsultaModel?> getById(String id) async {
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
  Future<void> save(ConsultaModel consulta) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (consulta.id.isEmpty) {
      consulta.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(consulta),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(ConsultaModel consulta) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(consulta),
      where: 'id = ?',
      whereArgs: [consulta.id],
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

  ConsultaModel _fromMap(Map<String, dynamic> map) {
    return ConsultaModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataConsulta: map['data_consulta'] ?? '',
      tipo: map['tipo'] ?? '',
      imagem: map['imagem'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(ConsultaModel consulta) {
    return {
      'id': consulta.id,
      'animal_id': consulta.animalId,
      'titulo': consulta.titulo,
      'descricao': consulta.descricao,
      'data_consulta': consulta.dataConsulta,
      'tipo': consulta.tipo,
      'imagem': consulta.imagem,
      'created_at': consulta.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

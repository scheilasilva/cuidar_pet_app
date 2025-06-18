import 'package:cuidar_pet_app/app/modules/vacinacao/repositories/vacinacao_repository_interface.dart';
import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/vacinacao_model.dart';

class VacinacaoRepository implements IVacinacaoRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'vacinacoes';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data_vacinacao TEXT NOT NULL,
        tipo TEXT NOT NULL,
        imagem TEXT,
        concluida INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE CASCADE
      );
    ''');
  }

  @override
  Future<List<VacinacaoModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'data_vacinacao ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<List<VacinacaoModel>> getByAnimalId(String animalId) async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'data_vacinacao ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<VacinacaoModel?> getById(String id) async {
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
  Future<void> save(VacinacaoModel vacinacao) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (vacinacao.id.isEmpty) {
      vacinacao.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(vacinacao),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(VacinacaoModel vacinacao) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(vacinacao),
      where: 'id = ?',
      whereArgs: [vacinacao.id],
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

  VacinacaoModel _fromMap(Map<String, dynamic> map) {
    return VacinacaoModel(
      id: map['id'] ?? '',
      animalId: map['animal_id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataVacinacao: map['data_vacinacao'] ?? '',
      tipo: map['tipo'] ?? '',
      imagem: map['imagem'],
      concluida: (map['concluida'] ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> _toMap(VacinacaoModel vacinacao) {
    return {
      'id': vacinacao.id,
      'animal_id': vacinacao.animalId,
      'titulo': vacinacao.titulo,
      'descricao': vacinacao.descricao,
      'data_vacinacao': vacinacao.dataVacinacao,
      'tipo': vacinacao.tipo,
      'imagem': vacinacao.imagem,
      'concluida': vacinacao.concluida ? 1 : 0,
      'created_at': vacinacao.createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

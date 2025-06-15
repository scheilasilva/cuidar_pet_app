import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/animal_model.dart';
import 'animal_repository_interface.dart';

class AnimalRepository implements IAnimalRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  static const String _tableName = 'animais';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        imagem TEXT,
        tipo_animal TEXT NOT NULL,
        idade INTEGER NOT NULL,
        genero TEXT NOT NULL,
        peso REAL NOT NULL
      );
    ''');
  }

  @override
  Future<List<AnimalModel>> getAll() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) => _fromMap(maps[i]));
  }

  @override
  Future<AnimalModel?> getById(String id) async {
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
  Future<AnimalModel?> getFirst() async {
    final db = await _databaseLocal.getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> save(AnimalModel animal) async {
    final db = await _databaseLocal.getDb();

    // Gerar ID se não existir
    if (animal.id.isEmpty) {
      animal.id = const Uuid().v4();
    }

    await db.insert(
      _tableName,
      _toMap(animal),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(AnimalModel animal) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(animal),
      where: 'id = ?',
      whereArgs: [animal.id],
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

  AnimalModel _fromMap(Map<String, dynamic> map) {
    return AnimalModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      imagem: map['imagem'],
      tipoAnimal: map['tipo_animal'] ?? '',
      idade: map['idade']?.toInt() ?? 0,
      genero: map['genero'] ?? '',
      peso: map['peso']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> _toMap(AnimalModel animal) {
    return {
      'id': animal.id,
      'nome': animal.nome,
      'imagem': animal.imagem,
      'tipo_animal': animal.tipoAnimal,
      'idade': animal.idade,
      'genero': animal.genero,
      'peso': animal.peso,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}
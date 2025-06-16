import 'package:cuidar_pet_app/app/shared/databases/database_local_pets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'user_repository_interface.dart';

class UserRepository implements IUserRepository {
  final DatabaseLocalPets _databaseLocal = DatabaseLocalPets();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String _tableName = 'users';

  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        imagem TEXT,
        created_at INTEGER,
        updated_at INTEGER
      );
    ''');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Pegar o usuário atual do Firebase Auth
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      // Buscar dados no banco local
      final db = await _databaseLocal.getDb();
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [firebaseUser.uid],
      );

      if (maps.isNotEmpty) {
        return _fromMap(maps.first);
      } else {
        // Se não existe no banco local, criar com dados do Firebase
        final userModel = UserModel(
          id: firebaseUser.uid,
          nome: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          imagem: firebaseUser.photoURL,
        );
        await save(userModel);
        return userModel;
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  @override
  Future<UserModel?> getById(String id) async {
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
  Future<void> save(UserModel user) async {
    final db = await _databaseLocal.getDb();
    await db.insert(
      _tableName,
      _toMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(UserModel user) async {
    final db = await _databaseLocal.getDb();
    await db.update(
      _tableName,
      _toMap(user),
      where: 'id = ?',
      whereArgs: [user.id],
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

  UserModel _fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      imagem: map['imagem'],
    );
  }

  Map<String, dynamic> _toMap(UserModel user) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return {
      'id': user.id,
      'nome': user.nome,
      'email': user.email,
      'imagem': user.imagem,
      'updated_at': now,
    };
  }

  @override
  void dispose() {
    // Implementar limpeza se necessário
  }
}

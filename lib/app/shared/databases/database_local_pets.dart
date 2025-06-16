import 'dart:io';
import 'package:cuidar_pet_app/app/modules/animal/repositories/animal_repository.dart';
import 'package:cuidar_pet_app/app/modules/exame/repositories/exame_repository.dart';
import 'package:cuidar_pet_app/app/modules/user/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseLocalPets {
  final String _baseNameDb = 'cuidar_pet';
  final int _versionDb = 1;
  final _lock = Lock();
  static Database? _db;
  static String? _currentUserId;

  // Banco temporário para quando não há usuário autenticado
  static const String _tempDbName = 'cuidar_pet_temp.db';

  // Flag para indicar se estamos usando o banco temporário
  bool _isUsingTempDb = false;

  DatabaseLocalPets();

  Future<void> _onCreate(Database db, int version) async {
    var batch = db.batch();
    
    AnimalRepository().create(batch);
    UserRepository().create(batch);
    ExameRepository().create(batch);

    await batch.commit();
  }

  Future<void> _onOpen(Database db) async {
    print('DB Pets version ${await db.getVersion()}');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
    if (oldVersion < 2) {
      // Exemplo de migração para versão 2
      // await db.execute('ALTER TABLE animais ADD COLUMN nova_coluna TEXT');
    }
  }

  Future<void> _onConfigureBeforeOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = OFF");
  }

  Future<void> _onConfigureAfterOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  /// Obtém o UID do usuário atual autenticado
  String? _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  /// Gera o nome do banco de dados baseado no UID do usuário
  /// Se não houver usuário autenticado, retorna o nome do banco temporário
  String _getDatabaseName() {
    final userId = _getCurrentUserId();
    if (userId == null) {
      _isUsingTempDb = true;
      return _tempDbName;
    }
    _isUsingTempDb = false;
    return '${_baseNameDb}_$userId.db';
  }

  Future<String> getPath() async {
    String databasesPath;
    if (Platform.isIOS) {
      databasesPath = (await getApplicationSupportDirectory()).path;
    } else {
      databasesPath = await getDatabasesPath();
    }

    final dbName = _getDatabaseName();
    final path = join(databasesPath, dbName);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (ex) {
      print('Erro ao criar diretório $ex');
    }

    return path;
  }

  /// Fecha o banco atual se o usuário mudou
  Future<void> _checkUserChange() async {
    final currentUserId = _getCurrentUserId();

    if (_currentUserId != currentUserId) {
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
      _currentUserId = currentUserId;
    }
  }

  Future<Database> getDb() async {
    // Verifica se o usuário mudou
    await _checkUserChange();

    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          _db = await openDatabase(
            await getPath(),
            version: _versionDb,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onConfigure: _onConfigureBeforeOpenDatabase,
            onOpen: _onOpen,
          );
          await _onConfigureAfterOpenDatabase(_db!);

          // Registra se estamos usando banco temporário ou de usuário
          print('Banco Pets aberto: ${_isUsingTempDb ? "TEMPORÁRIO" : "USUÁRIO: $_currentUserId"}');
        }
      });
    }
    return _db!;
  }

  /// Verifica se o usuário está autenticado antes de realizar operações no banco
  bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Método para verificar se estamos usando o banco temporário
  bool isUsingTemporaryDatabase() {
    return _isUsingTempDb;
  }

  /// Método para migrar dados do banco temporário para o banco do usuário após login
  Future<void> migrateFromTemporaryDatabase() async {
    if (!isUserAuthenticated() || !_isUsingTempDb) {
      return;
    }

    try {
      // Salva referência ao banco temporário
      final tempDb = _db;
      if (tempDb == null) return;

      // Fecha o banco temporário
      await tempDb.close();
      _db = null;

      // Obtém caminho do banco temporário
      String databasesPath;
      if (Platform.isIOS) {
        databasesPath = (await getApplicationSupportDirectory()).path;
      } else {
        databasesPath = await getDatabasesPath();
      }
      final tempPath = join(databasesPath, _tempDbName);

      // Verifica se o banco temporário existe
      if (!await File(tempPath).exists()) {
        print('Banco temporário não existe, não há dados para migrar');
        return;
      }

      // Abre o banco do usuário
      _isUsingTempDb = false;
      final userDb = await getDb();

      // Migrar dados dos animais
      final animais = await tempDb.query('animais');
      for (var animal in animais) {
        await userDb.insert('animais', animal);
      }

      // Aqui você pode adicionar migração para outras tabelas
      // final lembretes = await tempDb.query('lembretes');
      // for (var lembrete in lembretes) {
      //   await userDb.insert('lembretes', lembrete);
      // }

      print('Migração de dados dos pets concluída com sucesso');

      // Opcional: Deletar o banco temporário após a migração
      await File(tempPath).delete();
      print('Banco temporário deletado após migração');

    } catch (e) {
      print('Erro durante a migração de dados dos pets: $e');
    }
  }

  /// Método para limpar o banco quando o usuário faz logout
  Future<void> closeDatabase() async {
    await _lock.synchronized(() async {
      if (_db != null) {
        await _db!.close();
        _db = null;
        _currentUserId = null;
      }
    });
  }

  /// Método para deletar o banco de dados do usuário atual (se necessário)
  Future<void> deleteCurrentUserDatabase() async {
    try {
      await closeDatabase();
      final path = await getPath();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Banco de dados dos pets do usuário deletado: $path');
      }
    } catch (e) {
      print('Erro ao deletar banco de dados dos pets: $e');
    }
  }

  /// Lista todos os bancos de dados existentes (para debug/admin)
  Future<List<String>> listUserDatabases() async {
    try {
      String databasesPath;
      if (Platform.isIOS) {
        databasesPath = (await getApplicationSupportDirectory()).path;
      } else {
        databasesPath = await getDatabasesPath();
      }

      final directory = Directory(databasesPath);
      final files = await directory.list().toList();

      return files
          .where((file) => file.path.contains(_baseNameDb) && file.path.endsWith('.db'))
          .map((file) => basename(file.path))
          .toList();
    } catch (e) {
      print('Erro ao listar bancos de dados dos pets: $e');
      return [];
    }
  }
}
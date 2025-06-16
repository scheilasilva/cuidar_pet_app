import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../repositories/user_repository_interface.dart';
import 'user_service_interface.dart';

class UserService implements IUserService {
  final IUserRepository _repository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserService(this._repository);

  @override
  Future<UserModel?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }

  @override
  Future<UserModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(UserModel user) async {
    // Primeiro salvar no banco local
    if (user.id.isEmpty) {
      await _repository.save(user);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(user.id);
      if (existing != null) {
        await _repository.update(user);
      } else {
        await _repository.save(user);
      }
    }

    // Depois tentar atualizar no Firebase Auth (sem bloquear se der erro)
    try {
      await updateFirebaseProfile(user);
    } catch (e) {
      // Log do erro mas não impede a operação
      print('Aviso: Não foi possível sincronizar com Firebase: $e');
    }
  }

  @override
  Future<void> updateWithImage(UserModel user, String imagePath) async {
    final localImagePath = await saveImageLocally(imagePath);
    if (localImagePath != null) {
      user.imagem = localImagePath;
    }

    await saveOrUpdate(user);
  }

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      // Reautenticar o usuário
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Atualizar a senha
      await user.updatePassword(newPassword);
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Senha atual incorreta');
      }
      throw Exception('Erro ao atualizar senha: $e');
    }
  }

  @override
  Future<void> updateFirebaseProfile(UserModel user) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return;

      // Atualizar nome no Firebase Auth primeiro
      if (firebaseUser.displayName != user.nome) {
        await firebaseUser.updateDisplayName(user.nome);
      }

      // Atualizar foto se houver
      if (user.imagem != null && firebaseUser.photoURL != user.imagem) {
        await firebaseUser.updatePhotoURL(user.imagem);
      }

      // Para email, usar o novo método recomendado
      if (firebaseUser.email != user.email) {
        // Usar verifyBeforeUpdateEmail em vez de updateEmail
        await firebaseUser.verifyBeforeUpdateEmail(user.email);

        // Informar ao usuário que precisa verificar o email
        throw Exception('Um email de verificação foi enviado para ${user.email}. Verifique sua caixa de entrada para confirmar a alteração.');
      }

      await firebaseUser.reload();
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        throw Exception('Para alterar dados sensíveis, você precisa fazer login novamente');
      } else if (e.toString().contains('operation-not-allowed')) {
        throw Exception('Esta operação não está habilitada. Verifique as configurações do Firebase');
      } else if (e.toString().contains('invalid-email')) {
        throw Exception('Email inválido');
      } else if (e.toString().contains('email-already-in-use')) {
        throw Exception('Este email já está sendo usado por outra conta');
      } else if (e.toString().contains('too-many-requests')) {
        throw Exception('Muitas tentativas. Tente novamente mais tarde');
      }

      // Re-throw se for uma mensagem específica que queremos mostrar
      if (e.toString().contains('Um email de verificação foi enviado')) {
        rethrow;
      }

      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> delete(UserModel user) async {
    // Deletar imagem local se existir
    if (user.imagem != null && user.imagem!.isNotEmpty) {
      try {
        final file = File(user.imagem!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignorar erro se não conseguir deletar a imagem
      }
    }

    // Deletar do banco local
    await _repository.delete(user.id);

    // Deletar conta do Firebase Auth
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
      }
    } catch (e) {
      throw Exception('Erro ao deletar conta do Firebase: $e');
    }
  }

  @override
  Future<String?> saveImageLocally(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${directory.path}/profile_images');

      // Criar diretório se não existir
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // Gerar nome único para a imagem
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final newPath = '${profileImagesDir.path}/$fileName';

      // Copiar arquivo
      final originalFile = File(imagePath);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }
}

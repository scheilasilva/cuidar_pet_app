import 'package:cuidar_pet_app/app/modules/user/services/user_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/user/store/user_store.dart';
import 'package:mobx/mobx.dart';

part 'perfil_controller.g.dart';

class PerfilController = _PerfilControllerBase with _$PerfilController;

abstract class _PerfilControllerBase with Store {
  final IUserService _service;

  @observable
  UserStore user = UserStoreFactory.novo();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  _PerfilControllerBase(this._service);

  @computed
  bool get isFormValid {
    final u = user;
    return u.nome.isNotEmpty && u.email.isNotEmpty;
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  // Validação básica da senha (para senha atual)
  String? validatePasswordBasic(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }
    return null;
  }

  // Validação completa da senha (para nova senha)
  String? validatePasswordComplete(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (password.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }

    return null;
  }

  // Carregar usuário atual
  @action
  Future<void> loadCurrentUser() async {
    try {
      setLoading(true);
      clearError();

      final currentUser = await _service.getCurrentUser();
      if (currentUser != null) {
        user = UserStoreFactory.fromModel(currentUser);
      }
    } catch (e) {
      setError('Erro ao carregar perfil: $e');
    } finally {
      setLoading(false);
    }
  }

  // Salvar perfil
  @action
  Future<void> salvarPerfil() async {
    try {
      setLoading(true);
      clearError();

      await _service.saveOrUpdate(user.toModel());
      await loadCurrentUser();
    } catch (e) {
      setError('Erro ao salvar perfil: $e');
    } finally {
      setLoading(false);
    }
  }

  // Atualizar perfil com imagem
  @action
  Future<void> atualizarPerfilComImagem(String imagePath) async {
    try {
      setLoading(true);
      clearError();

      await _service.updateWithImage(user.toModel(), imagePath);
      await loadCurrentUser();
    } catch (e) {
      setError('Erro ao atualizar perfil: $e');
    } finally {
      setLoading(false);
    }
  }

  // Alterar senha
  @action
  Future<void> alterarSenha(String senhaAtual, String novaSenha, String confirmaSenha) async {
    try {
      setLoading(true);
      clearError();

      // Validação básica da senha atual
      String? currentPasswordError = validatePasswordBasic(senhaAtual);
      if (currentPasswordError != null) {
        setError(currentPasswordError);
        return;
      }

      // Validação completa da nova senha
      String? newPasswordError = validatePasswordComplete(novaSenha);
      if (newPasswordError != null) {
        setError(newPasswordError);
        return;
      }

      // Validar se as senhas coincidem
      if (novaSenha != confirmaSenha) {
        setError('As senhas não coincidem');
        return;
      }

      await _service.updatePassword(senhaAtual, novaSenha);
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  // Excluir conta com reautenticação
  @action
  Future<void> excluirContaComSenha(String senhaAtual) async {
    try {
      setLoading(true);
      clearError();

      // Validar senha atual
      String? passwordError = validatePasswordBasic(senhaAtual);
      if (passwordError != null) {
        setError(passwordError);
        return;
      }

      // Primeiro reautentica com a senha atual
      await _service.reauthenticateUser(senhaAtual);

      // Depois exclui a conta
      await _service.delete(user.toModel());
      user = UserStoreFactory.novo();
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  // Excluir conta (método antigo - mantido para compatibilidade)
  @action
  Future<void> excluirConta() async {
    try {
      setLoading(true);
      clearError();

      await _service.delete(user.toModel());
      user = UserStoreFactory.novo();
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    user = UserStoreFactory.novo();
  }

  // Método para tratar mensagens de erro (igual ao autenticacao_controller)
  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuário não encontrado';
    } else if (error.contains('wrong-password')) {
      return 'Senha incorreta';
    } else if (error.contains('email-already-in-use')) {
      return 'Este email já está em uso';
    } else if (error.contains('weak-password')) {
      return 'A senha deve conter pelo menos 6 caracteres';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido';
    } else if (error.contains('network-request-failed')) {
      return 'Erro de conexão. Verifique sua internet';
    } else if (error.contains('requires-recent-login')) {
      return 'Por segurança, confirme sua senha atual para continuar';
    } else {
      return 'Erro inesperado. Tente novamente';
    }
  }
}

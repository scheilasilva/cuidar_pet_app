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

  // Carregar usuário atual
  @action
  Future<void> loadCurrentUser() async {
    try {
      isLoading = true;
      errorMessage = null;

      final currentUser = await _service.getCurrentUser();
      if (currentUser != null) {
        user = UserStoreFactory.fromModel(currentUser);
      }
    } catch (e) {
      errorMessage = 'Erro ao carregar perfil: $e';
    } finally {
      isLoading = false;
    }
  }

  // Salvar perfil
  @action
  Future<void> salvarPerfil() async {
    try {
      isLoading = true;
      errorMessage = null;

      await _service.saveOrUpdate(user.toModel());
      await loadCurrentUser();
    } catch (e) {
      errorMessage = 'Erro ao salvar perfil: $e';
    } finally {
      isLoading = false;
    }
  }

  // Atualizar perfil com imagem
  @action
  Future<void> atualizarPerfilComImagem(String imagePath) async {
    try {
      isLoading = true;
      errorMessage = null;

      await _service.updateWithImage(user.toModel(), imagePath);
      await loadCurrentUser();
    } catch (e) {
      errorMessage = 'Erro ao atualizar perfil: $e';
    } finally {
      isLoading = false;
    }
  }

  // Alterar senha
  @action
  Future<void> alterarSenha(String senhaAtual, String novaSenha) async {
    try {
      isLoading = true;
      errorMessage = null;

      await _service.updatePassword(senhaAtual, novaSenha);
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
    }
  }

  // Excluir conta
  @action
  Future<void> excluirConta() async {
    try {
      isLoading = true;
      errorMessage = null;

      await _service.delete(user.toModel());
      user = UserStoreFactory.novo();
    } catch (e) {
      errorMessage = 'Erro ao excluir conta: $e';
    } finally {
      isLoading = false;
    }
  }

  // Limpar erro
  @action
  void clearError() {
    errorMessage = null;
  }

  // Resetar formulário
  @action
  void resetForm() {
    user = UserStoreFactory.novo();
  }
}

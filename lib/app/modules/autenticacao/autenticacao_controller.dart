import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/services/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'autenticacao_controller.g.dart';

class AutenticacaoController = _AutenticacaoControllerBase with _$AutenticacaoController;

abstract class _AutenticacaoControllerBase with Store {
  final AuthService _authService = Modular.get<AuthService>();

  @observable
  bool isLogin = true;

  @observable
  bool obscurePassword = true;

  @observable
  bool obscureConfirmPassword = true;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  void toggleAuthMode() {
    isLogin = !isLogin;
    clearError();
  }

  @action
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  @action
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
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


  // Validação do email
  String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email é obrigatório';
    }

    // Verificar se começa com letra minúscula
    if (!RegExp(r'^[a-z]').hasMatch(email)) {
      return 'Email deve começar com letra minúscula';
    }

    // Verificar formato do email
    if (!RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$').hasMatch(email)) {
      return 'Formato de email inválido';
    }

    return null;
  }

  // Validação da senha
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (password.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    }

    // Verificar se contém pelo menos uma letra maiúscula
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Senha deve conter pelo menos uma letra maiúscula';
    }

    // Verificar se contém pelo menos uma letra minúscula
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Senha deve conter pelo menos uma letra minúscula';
    }

    // Verificar se contém pelo menos um número
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Senha deve conter pelo menos um número';
    }

    // Verificar se contém pelo menos um caractere especial
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Senha deve conter pelo menos um caractere especial';
    }

    return null;
  }

  @action
  Future<void> login(String email, String password) async {
    try {
      setLoading(true);
      clearError();

      // Validar email
      String? emailError = validateEmail(email);
      if (emailError != null) {
        setError(emailError);
        return;
      }

      // Validar senha
      String? passwordError = validatePassword(password);
      if (passwordError != null) {
        setError(passwordError);
        return;
      }

      final user = await _authService.signInWithEmailAndPassword(email, password);

      if (user != null) {
        Modular.to.navigate('/$homeRoute');
      }
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> register(String name, String email, String password, String confirmPassword) async {
    try {
      setLoading(true);
      clearError();

      // Validar email
      String? emailError = validateEmail(email);
      if (emailError != null) {
        setError(emailError);
        return;
      }

      // Validar senha
      String? passwordError = validatePassword(password);
      if (passwordError != null) {
        setError(passwordError);
        return;
      }

      // Validar se as senhas coincidem
      if (password != confirmPassword) {
        setError('As senhas não coincidem');
        return;
      }

      final user = await _authService.createUserWithEmailAndPassword(email, password, name);

      if (user != null) {
        Modular.to.navigate('/$homeRoute');
      }
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> signInWithGoogle() async {
    try {
      setLoading(true);
      clearError();

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        Modular.to.navigate('/$homeRoute');
      }
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> resetPassword(String email) async {
    try {
      setLoading(true);
      clearError();

      // Validar email antes de enviar
      String? emailError = validateEmail(email);
      if (emailError != null) {
        setError(emailError);
        return;
      }

      await _authService.resetPassword(email);
      setError('Email de recuperação enviado com sucesso!');
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuário não encontrado';
    } else if (error.contains('wrong-password')) {
      return 'Senha incorreta';
    } else if (error.contains('email-already-in-use')) {
      return 'Este email já está em uso';
    } else if (error.contains('weak-password')) {
      return 'A senha é muito fraca';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido';
    } else if (error.contains('network-request-failed')) {
      return 'Erro de conexão. Verifique sua internet';
    } else {
      return 'Erro inesperado. Tente novamente';
    }
  }
}
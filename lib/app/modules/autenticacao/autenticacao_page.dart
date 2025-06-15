import 'package:cuidar_pet_app/app/modules/autenticacao/autenticacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oktoast/oktoast.dart';

class AutenticacaoPage extends StatefulWidget {
  const AutenticacaoPage({super.key});

  @override
  State<AutenticacaoPage> createState() => _AutenticacaoPageState();
}

class _AutenticacaoPageState extends State<AutenticacaoPage> {
  final AutenticacaoController controller = Modular.get<AutenticacaoController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (controller.isLogin) {
      controller.login(
        emailController.text,
        passwordController.text,
      );
    } else {
      controller.register(
        nameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      );
    }
  }

  void _handleForgotPassword() {
    if (emailController.text.isEmpty) {
      showToast('Digite seu email para recuperar a senha',
          position: ToastPosition.bottom);
      return;
    }
    controller.resetPassword(emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Observer(
        builder: (_) => Column(
          children: [
            // Cabeçalho com fundo arredondado e texto em arco
            Image.asset(
              'assets/img/autenticacao_logo.png',
              width: 500,
            ),
            const SizedBox(height: 12),

            // Toggle entre Login/Cadastro
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: controller.toggleAuthMode,
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.isLogin
                              ? const Color(0xFF00734B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              color: controller.isLogin ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.toggleAuthMode,
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !controller.isLogin
                              ? const Color(0xFF00734B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: !controller.isLogin ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mostrar erro se houver
            if (controller.errorMessage != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.errorMessage!.contains('sucesso')
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: controller.errorMessage!.contains('sucesso')
                        ? Colors.green.shade300
                        : Colors.red.shade300,
                  ),
                ),
                child: Text(
                  controller.errorMessage!,
                  style: TextStyle(
                    color: controller.errorMessage!.contains('sucesso')
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),

            // Conteúdo do formulário
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!controller.isLogin) ...[
                        const Text('Nome',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Text('Email',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Senha',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: controller.obscurePassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  controller.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),

                      if (!controller.isLogin) ...[
                        const SizedBox(height: 16),
                        const Text('Confirmar senha',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: controller.obscureConfirmPassword,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey),
                                onPressed: controller.toggleConfirmPasswordVisibility,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (controller.isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            child: const Text('Esqueceu sua senha?',
                                style:
                                TextStyle(color: Colors.blue, fontSize: 12)),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Botão principal com loading
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00734B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: Colors.grey.shade400,
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            controller.isLogin ? 'Entrar' : 'Cadastrar',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Botão do Google (apenas no login)
                      if (controller.isLogin) ...[
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('ou', style: TextStyle(color: Colors.grey)),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading ? null : controller.signInWithGoogle,
                            icon: Image.asset('assets/img/google_icon.png', height: 24),
                            label: const Text(
                              'Continue com Google',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFFE0F2EB),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:cuidar_pet_app/app/modules/perfil/perfil_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_perfil/bottom_sheet_perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PerfilController controller = Modular.get<PerfilController>();

  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    controller.loadCurrentUser();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Validação básica da senha atual
    String? currentPasswordError = controller.validatePasswordBasic(_currentPasswordController.text);
    if (currentPasswordError != null) {
      controller.setError(currentPasswordError);
      return;
    }

    // Validação completa da nova senha
    String? newPasswordError = controller.validatePasswordComplete(_newPasswordController.text);
    if (newPasswordError != null) {
      controller.setError(newPasswordError);
      return;
    }

    // Validar confirmação de senha
    if (_newPasswordController.text != _confirmPasswordController.text) {
      controller.setError('As senhas não coincidem');
      return;
    }

    controller.alterarSenha(
      _currentPasswordController.text,
      _newPasswordController.text,
      _confirmPasswordController.text,
    );
  }

  void _savePassword() async {
    _handleSubmit();

    if (controller.errorMessage == null) {
      _showSnackBar('Senha alterada com sucesso!');
      // Limpar campos
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar conta'),
        content: const Text(
          'Tem certeza que deseja desativar sua conta? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.excluirConta();
              if (controller.errorMessage == null) {
                Modular.to.navigate('/autenticacao/');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF00845A),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Observer(
      builder: (_) {
        if (controller.user.imagem != null &&
            controller.user.imagem!.isNotEmpty) {
          final file = File(controller.user.imagem!);
          if (file.existsSync()) {
            return ClipOval(
              child: Image.file(
                file,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            );
          }
        }

        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF00845A).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 90,
            color: Color(0xFF00845A),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00845A),
              size: 24,
            ),
            onPressed: () {
              Modular.to.navigate('/$homeRoute');
            },
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (controller.isLoading && controller.user.nome.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar erro se houver
                  if (controller.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.errorMessage!,
                              style: TextStyle(
                                color: controller.errorMessage!.contains('sucesso')
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: controller.clearError,
                            color: controller.errorMessage!.contains('sucesso')
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Foto de perfil
                        Container(
                          width: 170,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              _buildProfileImage(),
                              ElevatedButton(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => BottomSheetPerfil(
                                      controller: controller,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00845A),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(150, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.photo_camera_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('Editar perfil'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 150,
                          width: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Olá,',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  controller.user.nome.isNotEmpty
                                      ? controller.user.nome
                                      : 'Usuário',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (controller.user.email.isNotEmpty)
                                  Text(
                                    controller.user.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alterar senha
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alterar senha',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Campo de senha atual
                        const Text(
                          'Senha atual',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _currentPasswordController,
                            obscureText: _obscureCurrentPassword,
                            onChanged: (value) {
                              // Limpar erro quando o usuário começar a digitar
                              if (controller.errorMessage != null) {
                                controller.clearError();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCurrentPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Campo de nova senha
                        const Text(
                          'Nova senha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            onChanged: (value) {
                              // Limpar erro quando o usuário começar a digitar
                              if (controller.errorMessage != null) {
                                controller.clearError();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Campo de confirmar senha
                        const Text(
                          'Confirmar senha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            onChanged: (value) {
                              // Limpar erro quando o usuário começar a digitar
                              if (controller.errorMessage != null) {
                                controller.clearError();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Botão salvar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                            controller.isLoading ? null : _savePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00845A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                                : const Text(
                              'Salvar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Desativar conta
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Desativar conta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Botão desativar
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: controller.isLoading
                                ? null
                                : _showDeactivateDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Desativar conta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
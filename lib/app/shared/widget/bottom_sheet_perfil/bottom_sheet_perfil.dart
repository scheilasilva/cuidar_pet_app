import 'package:flutter/material.dart';

class BottomSheetPerfil extends StatefulWidget {
  const BottomSheetPerfil({super.key});

  @override
  State<BottomSheetPerfil> createState() => _BottomSheetPerfilState();
}

class _BottomSheetPerfilState extends State<BottomSheetPerfil> {
  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvarPerfil() {
    // Validar campos
    if (_nomeController.text.isEmpty ||
        _sobrenomeController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _showSnackBar('Preencha todos os campos');
      return;
    }

    // Implementar lógica para salvar o perfil
    _showSnackBar('Perfil salvo com sucesso!');
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF00845A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador de arraste
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título
          const Text(
            'Editar perfil',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),

          // Foto de perfil
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Color(0xFF00845A).withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF00845A),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                color: Color(0xFF00845A),
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Campo Nome
          const Text(
            'Nome',
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
              controller: _nomeController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo Sobrenome
          const Text(
            'Sobrenome',
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
              controller: _sobrenomeController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo E-mail
          const Text(
            'E-mail',
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botão Salvar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _salvarPerfil,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00845A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
import 'package:cuidar_pet_app/app/modules/perfil/perfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BottomSheetPerfil extends StatefulWidget {
  final PerfilController controller;

  const BottomSheetPerfil({
    super.key,
    required this.controller,
  });

  @override
  State<BottomSheetPerfil> createState() => _BottomSheetPerfilState();
}

class _BottomSheetPerfilState extends State<BottomSheetPerfil> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  File? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.controller.user.nome);
    _emailController = TextEditingController(text: widget.controller.user.email);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagemSelecionada = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao selecionar imagem: $e');
    }
  }

  Widget _buildProfileImage() {
    if (_imagemSelecionada != null) {
      return ClipOval(
        child: Image.file(
          _imagemSelecionada!,
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.controller.user.imagem != null &&
        widget.controller.user.imagem!.isNotEmpty) {
      final file = File(widget.controller.user.imagem!);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF00845A).withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF00845A),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.photo_camera_outlined,
        color: Color(0xFF00845A),
        size: 50,
      ),
    );
  }

  Future<void> _salvarPerfil() async {
    // Validar campos
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      _showSnackBar('Preencha todos os campos');
      return;
    }

    // Atualizar dados locais
    widget.controller.user.nome = _nomeController.text;
    widget.controller.user.email = _emailController.text;

    // Salvar
    if (_imagemSelecionada != null) {
      await widget.controller.atualizarPerfilComImagem(_imagemSelecionada!.path);
    } else {
      await widget.controller.salvarPerfil();
    }

    if (widget.controller.errorMessage == null) {
      _showSnackBar('Perfil salvo com sucesso!');
      Navigator.pop(context);
    }
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
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle do bottom sheet
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Conteúdo scrollável
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Observer(
                    builder: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        const Center(
                          child: Text(
                            'Editar perfil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Foto de perfil
                        Center(
                          child: GestureDetector(
                            onTap: _selecionarImagem,
                            child: _buildProfileImage(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mostrar erro se houver
                        if (widget.controller.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Text(
                              widget.controller.errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),

                        // Campo Nome
                        const Text(
                          'Nome',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
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

                        // Campo E-mail
                        const Text(
                          'E-mail',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            onPressed: widget.controller.isLoading ? null : _salvarPerfil,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00845A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: widget.controller.isLoading
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

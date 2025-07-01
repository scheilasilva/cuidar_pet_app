import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BottomSheetCadastro extends StatefulWidget {
  final String titulo;
  final String labelCampo1;
  final String labelCampo2;
  final String labelCampo3;
  final Function(String, String, String, String?)
      onSalvar; // Removido o parâmetro tipo

  const BottomSheetCadastro({
    super.key,
    required this.titulo,
    required this.labelCampo1,
    required this.labelCampo2,
    required this.labelCampo3,
    required this.onSalvar,
  });

  @override
  State<BottomSheetCadastro> createState() => _BottomSheetCadastroState();
}

class _BottomSheetCadastroState extends State<BottomSheetCadastro> {
  final TextEditingController _campo1Controller = TextEditingController();
  final TextEditingController _campo2Controller = TextEditingController();
  final TextEditingController _campo3Controller = TextEditingController();
  String? _imagemPath;
  bool _isLoadingImage = false;
  DateTime? _dataSelecionada;

  @override
  void dispose() {
    _campo1Controller.dispose();
    _campo2Controller.dispose();
    _campo3Controller.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007A63),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF007A63),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
        _campo3Controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _mostrarOpcoesImagem() {
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
                  Navigator.pop(context);
                  _selecionarImagem(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarImagem(ImageSource.camera);
                },
              ),
              if (_imagemPath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remover imagem',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _removerImagem();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selecionarImagem(ImageSource source) async {
    setState(() {
      _isLoadingImage = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagemPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  void _removerImagem() {
    setState(() {
      _imagemPath = null;
    });
  }

  Widget _buildImagePreview() {
    if (_imagemPath == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Imagem selecionada:',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_imagemPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final maxHeight = (screenHeight * 0.8) - keyboardHeight;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo 1
                  Text(
                    widget.labelCampo1,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  TextField(
                    controller: _campo1Controller,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Campo 2
                  Text(
                    widget.labelCampo2,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  TextField(
                    controller: _campo2Controller,
                    maxLines: 3,
                    // Aumentado para 3 linhas já que removemos o dropdown
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Campo 3 - Data
                  Text(
                    widget.labelCampo3,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: _selecionarData,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _campo3Controller,
                        decoration: InputDecoration(
                          hintText: 'Selecione a data',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF007A63),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildImagePreview(),

                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _isLoadingImage ? null : _mostrarOpcoesImagem,
                      icon: _isLoadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _imagemPath != null
                                  ? Icons.edit
                                  : Icons.add_photo_alternate_outlined,
                              color: const Color(0xFF007A63),
                            ),
                      label: Text(
                        _imagemPath != null
                            ? 'Alterar imagem'
                            : 'Adicionar imagem',
                        style: const TextStyle(color: Color(0xFF007A63)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF007A63)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_campo1Controller.text.isEmpty ||
                            _campo2Controller.text.isEmpty ||
                            _campo3Controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Preencha todos os campos'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Removido o parâmetro tipo da chamada
                        widget.onSalvar(
                          _campo1Controller.text,
                          _campo2Controller.text,
                          _campo3Controller.text,
                          _imagemPath,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007A63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

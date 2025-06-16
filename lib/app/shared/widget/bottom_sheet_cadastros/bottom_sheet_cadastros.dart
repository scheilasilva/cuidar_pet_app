import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BottomSheetCadastro extends StatefulWidget {
  final String titulo;
  final String labelCampo1;
  final String labelCampo2;
  final String labelCampo3;
  final Function(String, String, String, String, String?) onSalvar;

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
  String? _tipoSelecionado;
  String? _imagemPath;
  bool _isLoadingImage = false;

  final List<String> _tiposExame = [
    'Hemograma',
    'Raio-X',
    'Ultrassonografia',
    'Endoscopia',
    'Exame de fezes',
    'Outro'
  ];

  @override
  void dispose() {
    _campo1Controller.dispose();
    _campo2Controller.dispose();
    _campo3Controller.dispose();
    super.dispose();
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
                  title: const Text('Remover imagem', style: TextStyle(color: Colors.red)),
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
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 150,
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
          Text(
            widget.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

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
            ),
          ),
          const SizedBox(height: 16),

          // Campo 2
          Text(
            widget.labelCampo2,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextField(
            controller: _campo2Controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo 3
          Text(
            widget.labelCampo3,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextField(
            controller: _campo3Controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                itemHeight: 55,
                isExpanded: true,
                hint: Text(
                  'Selecione o tipo',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                value: _tipoSelecionado,
                icon: const Icon(Icons.arrow_drop_down),
                items: _tiposExame.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoSelecionado = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Preview da imagem selecionada
          _buildImagePreview(),

          // Botão adicionar imagem
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
                _imagemPath != null ? Icons.edit : Icons.add_photo_alternate_outlined,
                color: const Color(0xFF007A63),
              ),
              label: Text(
                _imagemPath != null ? 'Alterar imagem' : 'Adicionar imagem',
                style: const TextStyle(color: Color(0xFF007A63)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF007A63)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botão salvar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_campo1Controller.text.isEmpty ||
                    _campo2Controller.text.isEmpty ||
                    _campo3Controller.text.isEmpty ||
                    _tipoSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                widget.onSalvar(
                  _campo1Controller.text,
                  _campo2Controller.text,
                  _campo3Controller.text,
                  _tipoSelecionado!,
                  _imagemPath, // Passa o caminho da imagem temporária
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
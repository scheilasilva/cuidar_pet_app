import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroAnimalPage extends StatefulWidget {
  const CadastroAnimalPage({super.key});

  @override
  State<CadastroAnimalPage> createState() => _CadastroAnimalPageState();
}

class _CadastroAnimalPageState extends State<CadastroAnimalPage> {
  final controller = Modular.get<AnimalController>();
  File? _imagemSelecionada;

  final List<String> _tiposAnimais = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Roedor',
    'Peixe',
    'Réptil',
    'Outro'
  ];

  @override
  void initState() {
    super.initState();
    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        elevation: 0,
        title: const Text(
          'Cadastrar Pet',
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
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto do animal
                  Center(
                    child: GestureDetector(
                      onTap: _mostrarOpcoesImagem,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: _imagemSelecionada != null
                            ? ClipOval(
                          child: Image.file(
                            _imagemSelecionada!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.photo_camera_outlined,
                          color: Color(0xFF00845A),
                          size: 50,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Campo de nome
                  _buildLabel('Nome'),
                  _buildTextField(
                    value: controller.animal.nome,
                    onChanged: (value) => controller.animal.nome = value,
                  ),

                  const SizedBox(height: 20),

                  // Campo de tipo do animal
                  _buildLabel('Tipo do animal'),
                  _buildDropdown(
                    value: controller.animal.tipoAnimal.isEmpty ? null : controller.animal.tipoAnimal,
                    items: _tiposAnimais,
                    hint: 'Selecione o tipo',
                    onChanged: (value) => controller.animal.tipoAnimal = value!,
                  ),

                  const SizedBox(height: 20),

                  // Campo de idade
                  _buildLabel('Idade (anos)'),
                  _buildTextField(
                    value: controller.animal.idade.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final idade = int.tryParse(value) ?? 0;
                      controller.animal.idade = idade;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Campo de gênero
                  _buildLabel('Gênero'),
                  _buildDropdown(
                    value: controller.animal.genero,
                    items: const ['Macho', 'Fêmea'],
                    onChanged: (value) => controller.animal.genero = value!,
                  ),

                  const SizedBox(height: 20),

                  // Campo de peso
                  _buildLabel('Peso do animal'),
                  _buildPesoWidget(),

                  const SizedBox(height: 30),

                  // Botão de salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isFormValid ? _salvarAnimal : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005A3E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        hint: hint != null ? Text(hint) : null,
      ),
    );
  }

  Widget _buildPesoWidget() {
    return Observer(
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // Valor do peso
              Text(
                '${controller.animal.peso.toStringAsFixed(1)} KG',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Slider para o peso
              Slider(
                value: controller.animal.peso,
                min: 0,
                max: 100,
                divisions: 200,
                activeColor: const Color(0xFF00845A),
                inactiveColor: Colors.grey[300],
                onChanged: (value) => controller.animal.peso = value,
              ),
            ],
          ),
        );
      },
    );
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
                  Navigator.of(context).pop();
                  _selecionarImagem(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selecionarImagem(ImageSource.camera);
                },
              ),
              if (_imagemSelecionada != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remover imagem'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _imagemSelecionada = null;
                      controller.animal.imagem = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selecionarImagem(ImageSource source) async {
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
          controller.animal.imagem = image.path;
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
    }
  }

  Future<void> _salvarAnimal() async {
    try {
      await controller.salvarAnimal();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
import 'dart:io';

import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/animal/store/animal_store.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarPetBottomSheet extends StatefulWidget {
  final AnimalStore animal;
  final AnimalController controller;

  const EditarPetBottomSheet({
    super.key,
    required this.animal,
    required this.controller,
  });

  @override
  State<EditarPetBottomSheet> createState() => _EditarPetBottomSheetState();
}

class _EditarPetBottomSheetState extends State<EditarPetBottomSheet> {
  late TextEditingController _nomeController;
  late TextEditingController _dataController;
  File? _imagemSelecionada;
  String? _tipoSelecionado;
  String? _generoSelecionado;
  late int _idade;
  late double _peso;

  // Criar uma cópia local do animal para edição
  late AnimalStore _animalEditando;

  final List<String> _tiposAnimais = [
    'Cachorro',
    'Gato',
    'Pássaro',
    'Roedor',
    'Peixe',
    'Bovino',
    'Equino',
    'Suíno',
    'Ovino',
    'Galináceos',
    'Caprinos',
    'Outros',
  ];

  final List<String> _generos = ['Macho', 'Fêmea', 'Não identificado'];

  @override
  void initState() {
    super.initState();

    // Criar uma cópia do animal para edição
    _animalEditando = AnimalStore(
      id: widget.animal.id,
      nome: widget.animal.nome,
      imagem: widget.animal.imagem,
      tipoAnimal: widget.animal.tipoAnimal,
      idade: widget.animal.idade,
      genero: widget.animal.genero,
      peso: widget.animal.peso,
    );

    _nomeController = TextEditingController(text: _animalEditando.nome);
    _dataController = TextEditingController(text: '01/01/2020'); // Placeholder
    _tipoSelecionado = _animalEditando.tipoAnimal;
    _generoSelecionado = _animalEditando.genero;
    _idade = _animalEditando.idade;
    _peso = _animalEditando.peso;

    if (_animalEditando.imagem != null && _animalEditando.imagem!.isNotEmpty) {
      _imagemSelecionada = File(_animalEditando.imagem!);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Widget _buildDropdown2({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return DropdownButton2<String>(
      isExpanded: true,
      hint: hint != null
          ? Text(
              hint,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            )
          : null,
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
          border: Border.all(color: Colors.transparent),
        ),
        elevation: 0,
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        width: null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        offset: const Offset(0, -5),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      underline: Container(),
    );
  }

  Widget _buildPetImage() {
    if (_imagemSelecionada != null && _imagemSelecionada!.existsSync()) {
      return ClipOval(
        child: Image.file(
          _imagemSelecionada!,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        ),
      );
    } else if (_animalEditando.imagem != null &&
        _animalEditando.imagem!.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          _animalEditando.imagem!,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets,
                color: Color(0xFF00845A),
                size: 30,
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.pets,
          color: Color(0xFF00845A),
          size: 30,
        ),
      );
    }
  }

  Future<void> _selecionarImagem() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  Future<void> _salvarAlteracoes() async {
    try {
      // Atualizar os dados do animal local
      _animalEditando.nome = _nomeController.text;
      _animalEditando.tipoAnimal = _tipoSelecionado ?? '';
      _animalEditando.genero = _generoSelecionado ?? '';
      _animalEditando.idade = _idade;
      _animalEditando.peso = _peso;

      if (_imagemSelecionada != null) {
        _animalEditando.imagem = _imagemSelecionada!.path;
      }

      // Salvar através do método específico para atualização
      await widget.controller.atualizarAnimal(_animalEditando);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _excluirPet() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              Text('Tem certeza que deseja excluir ${_animalEditando.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await widget.controller.excluirAnimal(_animalEditando);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Text(
                        'Editar Pet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Foto do pet
                      Center(
                        child: GestureDetector(
                          onTap: _selecionarImagem,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF00845A),
                                width: 2,
                              ),
                            ),
                            child: _buildPetImage(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Nome
                      const Text(
                        'Nome',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
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
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Tipo do pet
                      const Text(
                        'Tipo do pet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      _buildDropdown2(
                        value: _tipoSelecionado,
                        items: _tiposAnimais,
                        hint: 'Selecione o tipo',
                        onChanged: (value) {
                          setState(() {
                            _tipoSelecionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      // Campo Gênero
                      const Text(
                        'Gênero',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      _buildDropdown2(
                        value: _generoSelecionado,
                        items: _generos,
                        hint: 'Selecione o gênero',
                        onChanged: (value) {
                          setState(() {
                            _generoSelecionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      // Campo Idade
                      const Text(
                        'Idade',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller:
                              TextEditingController(text: _idade.toString()),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _idade = int.tryParse(value) ?? 0;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Peso
                      const Text(
                        'Peso (kg)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: _peso.toStringAsFixed(1)),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _peso = double.tryParse(value) ?? 0.0;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvarAlteracoes,
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Botão Excluir pet
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _excluirPet,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Excluir pet',
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
              ),
            ],
          ),
        );
      },
    );
  }
}

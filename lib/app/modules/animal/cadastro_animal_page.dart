import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:io';

class CadastroAnimalPage extends StatefulWidget {
  const CadastroAnimalPage({super.key});

  @override
  State<CadastroAnimalPage> createState() => _CadastroAnimalPageState();
}

class _CadastroAnimalPageState extends State<CadastroAnimalPage> {
  final controller = Modular.get<AnimalController>();
  File? _imagemSelecionada;
  bool _editandoPeso = false;
  late TextEditingController _pesoController;
  late FocusNode _pesoFocusNode;

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
    _pesoController = TextEditingController();
    _pesoFocusNode = FocusNode();

    _pesoFocusNode.addListener(() {
      if (!_pesoFocusNode.hasFocus) {
        _finalizarEdicaoPeso();
      }
    });
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _pesoFocusNode.dispose();
    super.dispose();
  }

  void _iniciarEdicaoPeso() {
    setState(() {
      _editandoPeso = true;
      _pesoController.text = controller.animal.peso.toStringAsFixed(1);
    });

    // Dar foco após o próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pesoFocusNode.requestFocus();
      _pesoController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _pesoController.text.length,
      );
    });
  }

  void _finalizarEdicaoPeso() {
    final peso = double.tryParse(_pesoController.text);
    if (peso != null && peso >= 0 && peso <= 100) {
      controller.animal.peso = peso;
    }

    setState(() {
      _editandoPeso = false;
    });
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

                  const SizedBox(height: 16),

                  // Campo de nome
                  _buildLabel('Nome'),
                  _buildTextField(
                    value: controller.animal.nome,
                    onChanged: (value) => controller.animal.nome = value,
                  ),

                  const SizedBox(height: 20),

                  // Campo de tipo do animal
                  _buildLabel('Tipo do animal'),
                  _buildDropdown2(
                    value: controller.animal.tipoAnimal.isEmpty ? null : controller.animal.tipoAnimal,
                    items: _tiposAnimais,
                    hint: 'Selecione o tipo',
                    onChanged: (value) => controller.animal.tipoAnimal = value!,
                  ),

                  const SizedBox(height: 20),

                  // Campo de idade
                  _buildLabel('Idade'),
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
                  _buildDropdown2(
                    value: controller.animal.genero.isEmpty ? null : controller.animal.genero,
                    items: const ['Macho', 'Fêmea'],
                    hint: 'Selecione o gênero',
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
            vertical: 8,
          ),
          border: InputBorder.none,
        ),
      ),
    );
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
      items: items.map((String item) => DropdownMenuItem<String>(
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
      )).toList(),
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
          border: Border.all(color: Colors.transparent), // Remove qualquer borda
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
      underline: Container(), // Remove completamente o underline
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              // Valor do peso e unidade - EDITÁVEL INLINE
              GestureDetector(
                onTap: _editandoPeso ? null : _iniciarEdicaoPeso,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_editandoPeso)
                    // Campo de texto para edição
                      Flexible(
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: _pesoController,
                            focusNode: _pesoFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                            ],
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              final peso = double.tryParse(value);
                              if (peso != null && peso >= 0 && peso <= 100) {
                                controller.animal.peso = peso;
                              }
                            },
                            onSubmitted: (_) => _finalizarEdicaoPeso(),
                          ),
                        ),
                      )
                    else
                    // Texto normal para visualização
                      Text(
                        controller.animal.peso.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Kg',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4FC3F7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Seletor visual de peso (similar à imagem)
              Container(
                height: 120,
                child: _buildWeightRuler(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightRuler() {
    return Observer(
      builder: (context) {
        return GestureDetector(
          onPanUpdate: (details) {
            if (_editandoPeso) return; // Não alterar se estiver editando

            // Calcular novo peso baseado na posição do toque
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            double localX = details.localPosition.dx;
            double width = renderBox.size.width;

            // Converter posição para peso (0-100kg)
            double newWeight = (localX / width) * 100;
            newWeight = newWeight.clamp(0.0, 100.0);

            controller.animal.peso = double.parse(newWeight.toStringAsFixed(1));
          },
          child: Container(
            width: double.infinity,
            height: 120,
            child: CustomPaint(
              painter: WeightRulerPainter(
                currentWeight: controller.animal.peso,
                maxWeight: 100,
              ),
            ),
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

// Custom Painter para criar o seletor visual de peso
class WeightRulerPainter extends CustomPainter {
  final double currentWeight;
  final double maxWeight;

  WeightRulerPainter({
    required this.currentWeight,
    required this.maxWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barWidth = 4.0;
    final spacing = size.width / 20; // 20 barras

    // Desenhar barras de fundo
    for (int i = 0; i < 20; i++) {
      final x = (i * spacing) + (spacing / 2);
      final isSelected = (i / 20) * maxWeight <= currentWeight;

      // Altura variável das barras (similar à imagem)
      final heights = [60.0, 40.0, 80.0, 35.0, 70.0, 45.0, 85.0, 30.0, 75.0, 50.0,
        65.0, 40.0, 90.0, 35.0, 55.0, 45.0, 80.0, 40.0, 70.0, 60.0];
      final barHeight = heights[i % heights.length];

      paint.color = isSelected
          ? const Color(0xFF4FC3F7) // Azul ciano para barras selecionadas
          : Colors.grey.shade300;   // Cinza para barras não selecionadas

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY),
            width: barWidth,
            height: barHeight,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    // Desenhar linha indicadora (linha vertical destacada)
    final indicatorX = (currentWeight / maxWeight) * size.width;
    paint.color = const Color(0xFF4FC3F7);
    paint.strokeWidth = 2;

    canvas.drawLine(
      Offset(indicatorX, centerY - 50),
      Offset(indicatorX, centerY + 50),
      paint,
    );
  }

  @override
  bool shouldRepaint(WeightRulerPainter oldDelegate) {
    return oldDelegate.currentWeight != currentWeight;
  }
}
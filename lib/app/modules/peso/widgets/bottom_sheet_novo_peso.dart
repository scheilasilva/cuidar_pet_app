import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BottomSheetNovoPeso extends StatefulWidget {
  final double pesoInicial;
  final Function(double peso, DateTime data, String? observacao)? onSalvar;

  const BottomSheetNovoPeso({
    super.key,
    this.pesoInicial = 5.0,
    this.onSalvar,
  });

  @override
  State<BottomSheetNovoPeso> createState() => _BottomSheetNovoPesoState();
}

class _BottomSheetNovoPesoState extends State<BottomSheetNovoPeso> {
  final TextEditingController _observacaoController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final FocusNode _pesoFocusNode = FocusNode();

  late double _pesoSelecionado;
  DateTime _dataSelecionada = DateTime.now();
  bool _editandoPeso = false;

  @override
  void initState() {
    super.initState();
    _pesoSelecionado = widget.pesoInicial;

    _pesoFocusNode.addListener(() {
      if (!_pesoFocusNode.hasFocus) {
        _finalizarEdicaoPeso();
      }
    });
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    _pesoController.dispose();
    _pesoFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _pesoSelecionado > 0;
  }

  void _iniciarEdicaoPeso() {
    setState(() {
      _editandoPeso = true;
      _pesoController.text = _pesoSelecionado.toStringAsFixed(1);
    });

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
      _pesoSelecionado = peso;
    }

    setState(() {
      _editandoPeso = false;
    });
  }

  void _salvar() {
    if (_isFormValid && widget.onSalvar != null) {
      widget.onSalvar!(
        _pesoSelecionado,
        _dataSelecionada,
        _observacaoController.text.isEmpty ? null : _observacaoController.text,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00845A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

          // Conteúdo
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com título e data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Novo registro de peso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: _selecionarData,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00845A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(_dataSelecionada),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Widget de seleção de peso (igual ao cadastro)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
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
                                          setState(() {
                                            _pesoSelecionado = peso;
                                          });
                                        }
                                      },
                                      onSubmitted: (_) => _finalizarEdicaoPeso(),
                                    ),
                                  ),
                                )
                              else
                              // Texto normal para visualização
                                Text(
                                  _pesoSelecionado.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00845A),
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
                                    color: Color(0xFF00845A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Seletor visual de peso
                        Container(
                          height: 120,
                          child: _buildWeightRuler(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Observação',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  TextField(
                    controller: _observacaoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _salvar : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00845A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        'Salvar Peso',
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
        ],
      ),
    );
  }

  Widget _buildWeightRuler() {
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

        setState(() {
          _pesoSelecionado = double.parse(newWeight.toStringAsFixed(1));
        });
      },
      child: Container(
        width: double.infinity,
        height: 120,
        child: CustomPaint(
          painter: WeightRulerPainter(
            currentWeight: _pesoSelecionado,
            maxWeight: 100,
          ),
        ),
      ),
    );
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
      final heights = [
        60.0, 40.0, 80.0, 35.0, 70.0, 45.0, 85.0, 30.0, 75.0, 50.0,
        65.0, 40.0, 90.0, 35.0, 55.0, 45.0, 80.0, 40.0, 70.0, 60.0
      ];
      final barHeight = heights[i % heights.length];

      paint.color = isSelected
          ? const Color(0xFF00845A) // Verde para barras selecionadas
          : Colors.grey.shade300; // Cinza para barras não selecionadas

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
    paint.color = const Color(0xFF008400);
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
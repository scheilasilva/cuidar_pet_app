import 'package:flutter/material.dart';
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

  late double _pesoSelecionado;
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pesoSelecionado = widget.pesoInicial;
  }

  bool get _isFormValid {
    return _pesoSelecionado > 0;
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
          Flexible(
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
                          fontSize: 20,
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

                  const SizedBox(height: 32),

                  // Widget de seleção de peso
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        // Valor do peso
                        Text(
                          '${_pesoSelecionado.toStringAsFixed(1)} KG',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00845A),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Slider para o peso
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF00845A),
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: const Color(0xFF00845A),
                            overlayColor: const Color(0xFF00845A).withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                            trackHeight: 6,
                          ),
                          child: Slider(
                            value: _pesoSelecionado,
                            min: 0.1,
                            max: 100.0,
                            divisions: 999,
                            onChanged: (value) {
                              setState(() {
                                _pesoSelecionado = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Indicadores de min e max
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0.1 KG',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '100.0 KG',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Campo Observação (opcional)
                  const Text(
                    'Observação (opcional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _observacaoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Adicione uma observação sobre a pesagem...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
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

                  const SizedBox(height: 32),

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

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }
}

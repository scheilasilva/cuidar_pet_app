import 'package:cuidar_pet_app/app/modules/calendario/widgets/categoria_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomSheetNovoLembrete extends StatefulWidget {
  final DateTime dataSelecionada;
  final Function(String titulo, String descricao, DateTime data,
      String categoria, bool concluido)? onSalvar;

  const BottomSheetNovoLembrete({
    super.key,
    required this.dataSelecionada,
    this.onSalvar,
  });

  @override
  State<BottomSheetNovoLembrete> createState() =>
      _BottomSheetNovoLembreteState();
}

class _BottomSheetNovoLembreteState extends State<BottomSheetNovoLembrete> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  late DateTime _dataSelecionada;
  String? _categoriaSelecionada;
  bool _concluido = false;

  @override
  void initState() {
    super.initState();
    // Normalizar a data selecionada para evitar problemas de fuso horário
    _dataSelecionada = DateTime(
      widget.dataSelecionada.year,
      widget.dataSelecionada.month,
      widget.dataSelecionada.day,
    );
  }

  bool get _isFormValid {
    return _tituloController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _categoriaSelecionada != null;
  }

  void _salvar() {
    if (_isFormValid && widget.onSalvar != null) {
      // Garantir que a data seja normalizada antes de salvar
      final dataNormalizada = DateTime(
        _dataSelecionada.year,
        _dataSelecionada.month,
        _dataSelecionada.day,
        12, // Definir meio-dia para evitar problemas de fuso horário
        0,
        0,
      );

      widget.onSalvar!(
        _tituloController.text,
        _descricaoController.text,
        dataNormalizada,
        _categoriaSelecionada!,
        _concluido,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
        // Normalizar a data selecionada
        _dataSelecionada = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
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
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com título e data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Novo lembrete',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: _selecionarData,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
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

                  // Campo Título do lembrete
                  const Text(
                    'Título do lembrete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _tituloController,
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
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  // Categoria
                  const Text(
                    'Categoria',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                      CategoriaHelper.getTodasCategorias().map((categoria) {
                        final isSelected = _categoriaSelecionada == categoria;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _categoriaSelecionada = categoria;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                CategoriaHelper.getCorCategoria(categoria),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.black, width: 3)
                                    : null,
                              ),
                              child: Icon(
                                CategoriaHelper.getIconeCategoria(categoria),
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Campo Descrição do lembrete
                  const Text(
                    'Descrição do lembrete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _descricaoController,
                    maxLines: 4,
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
                    onChanged: (_) => setState(() {}),
                  ),

                  // Checkbox Concluído
                  Row(
                    children: [
                      const Text(
                        'Concluído:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: _concluido,
                        onChanged: (bool? value) {
                          setState(() {
                            _concluido = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF00845A),
                      ),
                    ],
                  ),

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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}

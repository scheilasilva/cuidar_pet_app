import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class BottomSheetAlimentacao extends StatefulWidget {
  final Function(String titulo, String horario, String alimento, String observacao)? onSalvar;

  const BottomSheetAlimentacao({
    super.key,
    this.onSalvar,
  });

  @override
  State<BottomSheetAlimentacao> createState() => _BottomSheetAlimentacaoState();
}

class _BottomSheetAlimentacaoState extends State<BottomSheetAlimentacao> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _alimentoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  String? _horarioSelecionado;

  final List<String> _horarios = [
    'Manhã: 6:00',
    'Manhã: 7:00',
    'Manhã: 8:00',
    'Manhã: 9:00',
    'Manhã: 10:00',
    'Manhã: 11:00',
    'Tarde: 12:00',
    'Tarde: 13:00',
    'Tarde: 14:00',
    'Tarde: 15:00',
    'Tarde: 16:00',
    'Tarde: 17:00',
    'Noite: 18:00',
    'Noite: 19:00',
    'Noite: 20:00',
    'Noite: 21:00',
    'Noite: 22:00',
  ];

  bool get _isFormValid {
    return _tituloController.text.isNotEmpty &&
        _horarioSelecionado != null &&
        _alimentoController.text.isNotEmpty &&
        _observacaoController.text.isNotEmpty;
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

  void _salvar() {
    if (_isFormValid && widget.onSalvar != null) {
      widget.onSalvar!(
        _tituloController.text,
        _horarioSelecionado!,
        _alimentoController.text,
        _observacaoController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.66,
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
                        'Nova refeição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Título da refeição
                      const Text(
                        'Título da refeição',
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
                          controller: _tituloController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Horário
                      const Text(
                        'Horário',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      _buildDropdown2(
                        value: _horarioSelecionado,
                        items: _horarios,
                        onChanged: (String? newValue) {
                          setState(() {
                            _horarioSelecionado = newValue;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      // Campo Alimento
                      const Text(
                        'Alimento',
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
                          controller: _alimentoController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo Observação
                      const Text(
                        'Observação',
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
                          controller: _observacaoController,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botão Adicionar
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
                            'Adicionar',
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

  @override
  void dispose() {
    _tituloController.dispose();
    _alimentoController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }
}

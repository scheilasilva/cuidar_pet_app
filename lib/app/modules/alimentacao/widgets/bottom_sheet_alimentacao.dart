import 'package:flutter/material.dart';

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
                  // Título
                  const Text(
                    'Nova refeição',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Campo Título da refeição
                  const Text(
                    'Título da refeição',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      hintText: 'Título da refeição',
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
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  // Campo Horário
                  const Text(
                    'Horário',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _horarioSelecionado,
                    decoration: InputDecoration(
                      hintText: 'Selecione o horário da refeição',
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
                    items: _horarios.map((String horario) {
                      return DropdownMenuItem<String>(
                        value: horario,
                        child: Text(horario),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _horarioSelecionado = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo Alimento
                  const Text(
                    'Alimento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alimentoController,
                    decoration: InputDecoration(
                      hintText: 'Alimento',
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
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  // Campo Observação
                  const Text(
                    'Observação',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _observacaoController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Descrição',
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
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 32),

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
    _alimentoController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }
}

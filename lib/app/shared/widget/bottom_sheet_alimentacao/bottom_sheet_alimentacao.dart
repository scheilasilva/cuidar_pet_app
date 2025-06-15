import 'package:flutter/material.dart';

class BottomSheetAlimentacao extends StatefulWidget {
  const BottomSheetAlimentacao({super.key});

  @override
  State<BottomSheetAlimentacao> createState() => _BottomSheetAlimentacaoState();
}

class _BottomSheetAlimentacaoState extends State<BottomSheetAlimentacao> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _alimentoController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  String? _horarioSelecionado;

  final List<String> _horarios = [
    'Manhã',
    'Meio dia',
    'Tarde',
    'Noite',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _alimentoController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _adicionarRefeicao() {
    // Aqui você implementaria a lógica para adicionar a refeição
    final refeicao = {
      'titulo': _tituloController.text,
      'horario': _horarioSelecionado,
      'alimento': _alimentoController.text,
      'observacao': _observacaoController.text,
    };

    print('Refeição adicionada: $refeicao');
    Navigator.pop(context, refeicao);
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
          const Text(
            'Nova refeição',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Título da refeição
          const Text(
            'Título da refeição',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextField(
            controller: _tituloController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Horário
          const Text(
            'Horário',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                itemHeight: 55,
                hint: Text(
                  'Selecione o horário da refeição',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                value: _horarioSelecionado,
                icon: const Icon(Icons.arrow_drop_down),
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
            ),
          ),
          const SizedBox(height: 16),

          // Alimento
          const Text(
            'Alimento',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextField(
            controller: _alimentoController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          // Observação
          const Text(
            'Observação',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          TextField(
            controller: _observacaoController,
            maxLines: 4,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 24),

          // Botão adicionar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _adicionarRefeicao,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Adicionar',
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
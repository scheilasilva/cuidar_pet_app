import 'package:flutter/material.dart';

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

  void _adicionarImagem() {
    // Aqui você implementaria a lógica para selecionar uma imagem
    // Por exemplo, usando image_picker
    setState(() {
      _imagemPath = 'caminho_da_imagem_selecionada';
    });
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

          // Botão adicionar imagem
          Center(
            child: OutlinedButton.icon(
              onPressed: _adicionarImagem,
              icon: const Icon(Icons.add_photo_alternate_outlined,
                  color: Color(0xFF007A63)),
              label: const Text(
                'Adicionar imagem',
                style: TextStyle(color: Color(0xFF007A63)),
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
                  _imagemPath,
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

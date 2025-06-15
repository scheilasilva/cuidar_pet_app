import 'package:flutter/material.dart';

class BottomSheetExit extends StatefulWidget {
  final String mensagem;
  final String textoCancelar;
  final String textoConfirmar;

  const BottomSheetExit({
    super.key,
    required this.mensagem,
    required this.textoCancelar,
    required this.textoConfirmar,
  });

  static Future<bool> show({
    required BuildContext context,
    required String mensagem,
    String textCancelar = 'VOLTAR',
    required String textoConfirmar,
  }) async {
    return (await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetExit(
          mensagem: mensagem,
          textoCancelar: textCancelar,
          textoConfirmar: textoConfirmar,
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    )) ??
        false;
  }

  @override
  State<BottomSheetExit> createState() => _ConfirmarBottonSheet();
}

class _ConfirmarBottonSheet extends State<BottomSheetExit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 38),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.mensagem,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  widget.textoCancelar,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF007A63),
                  ),
                ),
              ),
              const VerticalDivider(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  widget.textoConfirmar,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

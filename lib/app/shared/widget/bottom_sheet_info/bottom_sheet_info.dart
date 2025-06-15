import 'package:flutter/material.dart';

class BottomSheetInfo extends StatelessWidget {
  final String titulo;
  final String mensagem;

  const BottomSheetInfo({
    super.key,
    required this.titulo,
    required this.mensagem,
  });

  static Future<void> show({
    required BuildContext context,
    required String titulo,
    required String mensagem,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BottomSheetInfo(
        titulo: titulo,
        mensagem: mensagem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Text(
                mensagem,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

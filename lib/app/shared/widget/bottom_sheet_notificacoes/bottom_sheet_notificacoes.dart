import 'package:flutter/material.dart';

class BottomSheetNotificacoes extends StatefulWidget {
  const BottomSheetNotificacoes({super.key});

  @override
  State<BottomSheetNotificacoes> createState() => _BottomSheetNotificacoesState();
}

class _BottomSheetNotificacoesState extends State<BottomSheetNotificacoes> {
  bool alimentacao = true;
  bool vacinacao = true;
  bool exame = true;
  bool tratamento = true;

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
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marque para ativar ou desativar as notificações',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildSwitchTile('Alimentação', alimentacao, (val) {
            setState(() => alimentacao = val);
          }),
          buildSwitchTile('Vacinação', vacinacao, (val) {
            setState(() => vacinacao = val);
          }),
          buildSwitchTile('Exame', exame, (val) {
            setState(() => exame = val);
          }),
          buildSwitchTile('Tratamento', tratamento, (val) {
            setState(() => tratamento = val);
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF007A63),
          ),
        ],
      ),
    );
  }
}

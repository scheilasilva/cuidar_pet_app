import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart';
import 'package:flutter/material.dart';

class BottomSheetNotificacoes extends StatefulWidget {
  const BottomSheetNotificacoes({super.key});

  @override
  State<BottomSheetNotificacoes> createState() => _BottomSheetNotificacoesState();
}

class _BottomSheetNotificacoesState extends State<BottomSheetNotificacoes> {
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  bool alimentacao = true;
  bool vacinacao = true;
  bool exame = true;
  bool tratamento = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await Future.wait([
        _settingsService.isAlimentacaoEnabled(),
        _settingsService.isVacinacaoEnabled(),
        _settingsService.isExameEnabled(),
        _settingsService.isTratamentoEnabled(),
      ]);

      setState(() {
        alimentacao = settings[0];
        vacinacao = settings[1];
        exame = settings[2];
        tratamento = settings[3];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateSetting(String type, bool value) async {
    switch (type) {
      case 'alimentacao':
        await _settingsService.setAlimentacaoEnabled(value);
        break;
      case 'vacinacao':
        await _settingsService.setVacinacaoEnabled(value);
        break;
      case 'exame':
        await _settingsService.setExameEnabled(value);
        break;
      case 'tratamento':
        await _settingsService.setTratamentoEnabled(value);
        break;
    }
  }

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

          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            buildSwitchTile('Alimentação', alimentacao, (val) async {
              setState(() => alimentacao = val);
              await _updateSetting('alimentacao', val);
            }),
            buildSwitchTile('Vacinação', vacinacao, (val) async {
              setState(() => vacinacao = val);
              await _updateSetting('vacinacao', val);
            }),
            buildSwitchTile('Exame', exame, (val) async {
              setState(() => exame = val);
              await _updateSetting('exame', val);
            }),
            buildSwitchTile('Tratamento', tratamento, (val) async {
              setState(() => tratamento = val);
              await _updateSetting('tratamento', val);
            }),
          ],

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

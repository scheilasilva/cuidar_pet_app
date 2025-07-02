import 'package:shared_preferences/shared_preferences.dart';

class NotificacoesSettingsService {
  static const String _alimentacaoKey = 'notificacoes_alimentacao';
  static const String _vacinacaoKey = 'notificacoes_vacinacao';
  static const String _exameKey = 'notificacoes_exame';
  static const String _tratamentoKey = 'notificacoes_tratamento';

  Future<bool> isAlimentacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_alimentacaoKey) ?? true; // Padrão: habilitado
  }

  Future<bool> isVacinacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vacinacaoKey) ?? true;
  }

  Future<bool> isExameEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_exameKey) ?? true;
  }

  Future<bool> isTratamentoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tratamentoKey) ?? true;
  }

  Future<void> setAlimentacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_alimentacaoKey, enabled);
  }

  Future<void> setVacinacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vacinacaoKey, enabled);
  }

  Future<void> setExameEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_exameKey, enabled);
  }

  Future<void> setTratamentoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tratamentoKey, enabled);
  }
}

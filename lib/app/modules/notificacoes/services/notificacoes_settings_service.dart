import 'package:shared_preferences/shared_preferences.dart';

class NotificacoesSettingsService {
  static const String _alimentacaoKey = 'notificacoes_alimentacao_enabled';
  static const String _vacinacaoKey = 'notificacoes_vacinacao_enabled';
  static const String _consultaKey = 'notificacoes_consulta_enabled';
  static const String _keyExame = 'notificacoes_exame_enabled';
  static const String _keyTratamento = 'notificacoes_tratamento_enabled';

  // Alimentação
  Future<bool> isAlimentacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_alimentacaoKey) ?? true;
  }

  Future<void> setAlimentacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_alimentacaoKey, enabled);
  }

  // Vacinação
  Future<bool> isVacinacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vacinacaoKey) ?? true;
  }

  Future<void> setVacinacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vacinacaoKey, enabled);
  }

  // Consulta
  Future<bool> isConsultaEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consultaKey) ?? true;
  }

  Future<void> setConsultaEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consultaKey, enabled);
  }

  // Exame
  Future<bool> isExameEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyExame) ?? true;
  }

  Future<void> setExameEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyExame, enabled);
  }

  // Tratamento
  Future<bool> isTratamentoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTratamento) ?? true;
  }

  Future<void> setTratamentoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTratamento, enabled);
  }

  // Obter todas as configurações
  Future<Map<String, bool>> getAllSettings() async {
    return {
      'alimentacao': await isAlimentacaoEnabled(),
      'vacinacao': await isVacinacaoEnabled(),
      'consulta': await isConsultaEnabled(),
      'exame': await isExameEnabled(),
      'tratamento': await isTratamentoEnabled(),
    };
  }

  // Habilitar/desabilitar todas as notificações
  Future<void> setAllEnabled(bool enabled) async {
    await setAlimentacaoEnabled(enabled);
    await setVacinacaoEnabled(enabled);
    await setConsultaEnabled(enabled);
    await setExameEnabled(enabled);
    await setTratamentoEnabled(enabled);
  }
}

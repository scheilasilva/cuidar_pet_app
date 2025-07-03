import 'package:shared_preferences/shared_preferences.dart';

class NotificacoesSettingsService {
  static const String _keyAlimentacao = 'notificacoes_alimentacao_enabled';
  static const String _keyVacinacao = 'notificacoes_vacinacao_enabled';
  static const String _keyConsulta = 'notificacoes_consulta_enabled';
  static const String _keyExame = 'notificacoes_exame_enabled';
  static const String _keyTratamento = 'notificacoes_tratamento_enabled';

  // ALIMENTAÇÃO
  Future<bool> isAlimentacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAlimentacao) ?? true; // Habilitado por padrão
  }

  Future<void> setAlimentacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlimentacao, enabled);
  }

  // VACINAÇÃO
  Future<bool> isVacinacaoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyVacinacao) ?? true; // Habilitado por padrão
  }

  Future<void> setVacinacaoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVacinacao, enabled);
  }

  // CONSULTA
  Future<bool> isConsultaEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyConsulta) ?? true; // Habilitado por padrão
  }

  Future<void> setConsultaEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyConsulta, enabled);
  }

  // EXAME
  Future<bool> isExameEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyExame) ?? true; // Habilitado por padrão
  }

  Future<void> setExameEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyExame, enabled);
  }

  // TRATAMENTO
  Future<bool> isTratamentoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTratamento) ?? true; // Habilitado por padrão
  }

  Future<void> setTratamentoEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTratamento, enabled);
  }

  // Método para obter todas as configurações
  Future<Map<String, bool>> getAllSettings() async {
    return {
      'alimentacao': await isAlimentacaoEnabled(),
      'vacinacao': await isVacinacaoEnabled(),
      'consulta': await isConsultaEnabled(),
      'exame': await isExameEnabled(),
      'tratamento': await isTratamentoEnabled(),
    };
  }

  // Método para habilitar/desabilitar todas as notificações
  Future<void> setAllEnabled(bool enabled) async {
    await setAlimentacaoEnabled(enabled);
    await setVacinacaoEnabled(enabled);
    await setConsultaEnabled(enabled);
    await setExameEnabled(enabled);
    await setTratamentoEnabled(enabled);
  }
}

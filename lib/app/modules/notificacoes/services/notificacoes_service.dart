import 'package:cuidar_pet_app/app/modules/notificacoes/models/notificacoes_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../repositories/notificacoes_repository.dart';

class NotificacoesService {
  static final NotificacoesService _instance = NotificacoesService._internal();
  factory NotificacoesService() => _instance;
  NotificacoesService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final NotificacoesRepository _repository = NotificacoesRepository();

  Future<void> initialize() async {
    print('🚀 Inicializando serviço de notificações...');

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    final bool? initialized = await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    print('📱 Notificações inicializadas: $initialized');

    await _requestAllPermissions();
    await checkNotificationSettings();
  }

  Future<void> _requestAllPermissions() async {
    print('🔐 Verificando todas as permissões...');

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    print('📱 Versão do Android: API $sdkInt');

    final notificationStatus = await Permission.notification.status;
    print('📋 Permissão de notificação: $notificationStatus');

    if (notificationStatus.isDenied) {
      final result = await Permission.notification.request();
      print('📋 Resultado da solicitação: $result');
    }

    if (sdkInt >= 31) {
      try {
        final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
        print('⏰ Permissão de alarme exato: $exactAlarmStatus');

        if (exactAlarmStatus.isDenied) {
          final result = await Permission.scheduleExactAlarm.request();
          print('⏰ Resultado alarme exato: $result');
        }
      } catch (e) {
        print('⚠️ Erro ao verificar permissão de alarme exato: $e');
      }
    }

    try {
      final batteryOptimization = await Permission.ignoreBatteryOptimizations.status;
      print('🔋 Otimização de bateria: $batteryOptimization');
    } catch (e) {
      print('⚠️ Erro ao verificar otimização de bateria: $e');
    }

    await _checkExactAlarmCapability();
  }

  Future<void> _checkExactAlarmCapability() async {
    try {
      final androidImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        final canScheduleExactAlarms = await androidImpl.canScheduleExactNotifications();
        print('🎯 Pode agendar alarmes exatos: $canScheduleExactAlarms');
      }
    } catch (e) {
      print('⚠️ Erro ao verificar capacidade de alarmes exatos: $e');
    }
  }

  Future<void> checkNotificationSettings() async {
    print('⚙️ Verificando configurações de notificação...');

    final bool? areNotificationsEnabled = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    print('🔔 Notificações habilitadas no sistema: $areNotificationsEnabled');
    await checkPendingNotifications();
  }

  Future<void> checkPendingNotifications() async {
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('📋 Notificações pendentes: ${pendingNotifications.length}');

    for (var notification in pendingNotifications) {
      print('- ID: ${notification.id}, Título: ${notification.title}');
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('👆 Notificação tocada: ${notificationResponse.payload}');

    // Marcar como enviada quando a notificação for tocada
    if (notificationResponse.payload != null) {
      final payload = notificationResponse.payload!;
      if (payload.startsWith('alimentacao_')) {
        final alimentacaoId = payload.replaceFirst('alimentacao_', '');
        print('🔍 Marcando notificação como enviada para alimentacao ID: $alimentacaoId');
        _markNotificationAsSent(alimentacaoId);
      } else if (payload.startsWith('vacinacao_')) {
        final vacinacaoId = payload.replaceFirst('vacinacao_', '');
        print('🔍 Marcando notificação como enviada para vacinacao ID: $vacinacaoId');
        _markNotificationAsSent(vacinacaoId);
      } else if (payload.startsWith('consulta_')) {
        final consultaId = payload.replaceFirst('consulta_', '');
        print('🔍 Marcando notificação como enviada para consulta ID: $consultaId');
        _markNotificationAsSent(consultaId);
      }
    }
  }

  Future<void> _markNotificationAsSent(String relatedId) async {
    try {
      print('🔍 Procurando notificação com related_id: $relatedId');
      await _repository.markAsSentByRelatedId(relatedId);
      print('✅ Notificação marcada como enviada para related_id: $relatedId');
    } catch (e) {
      print('❌ Erro ao marcar notificação como enviada: $e');
    }
  }

  // ALIMENTAÇÃO
  Future<void> scheduleAlimentacaoNotification({
    required String alimentacaoId,
    required String titulo,
    required String alimento,
    required String horario,
    required String animalNome,
    required String animalId,
  }) async {
    print('🔔 Agendando notificação de alimentação para: $horario');

    final DateTime? scheduledTime = _parseHorarioToDateTime(horario);

    if (scheduledTime == null) {
      print('❌ Erro: Não foi possível fazer parse do horário: $horario');
      return;
    }

    final DateTime notificationTime = scheduledTime.subtract(const Duration(minutes: 10));

    if (notificationTime.isBefore(DateTime.now())) {
      final tomorrow = notificationTime.add(const Duration(days: 1));
      await _scheduleAlimentacaoNotification(
        alimentacaoId: alimentacaoId,
        titulo: titulo,
        alimento: alimento,
        animalNome: animalNome,
        animalId: animalId,
        notificationTime: tomorrow,
      );
      return;
    }

    await _scheduleAlimentacaoNotification(
      alimentacaoId: alimentacaoId,
      titulo: titulo,
      alimento: alimento,
      animalNome: animalNome,
      animalId: animalId,
      notificationTime: notificationTime,
    );
  }

  Future<void> _scheduleAlimentacaoNotification({
    required String alimentacaoId,
    required String titulo,
    required String alimento,
    required String animalNome,
    required String animalId,
    required DateTime notificationTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alimentacao_channel',
      'Alimentação',
      channelDescription: 'Notificações de alimentação dos pets',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    AndroidScheduleMode scheduleMode = sdkInt >= 31
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.exact;

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        alimentacaoId.hashCode,
        '🍽️ Hora da alimentação!',
        'Em 10 minutos: $titulo - $alimento para $animalNome',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'alimentacao_$alimentacaoId',
        matchDateTimeComponents: null,
      );

      print('✅ Notificação de alimentação agendada com sucesso!');
      print('🆔 ID da notificação: ${alimentacaoId.hashCode}');
      print('📅 Horário agendado: $scheduledDate');

    } catch (e) {
      print('❌ Erro ao agendar notificação de alimentação: $e');
    }

    // Salvar no banco como agendada (sem sentTime)
    await _saveScheduledNotificacao(
      type: 'alimentacao',
      title: '🍽️ Hora da alimentação!',
      body: 'Em 10 minutos: $titulo - $alimento para $animalNome',
      scheduledTime: notificationTime,
      relatedId: alimentacaoId,
      animalId: animalId,
    );

    print('💾 Notificação de alimentação salva no banco com related_id: $alimentacaoId');
  }

  // VACINAÇÃO
  Future<void> scheduleVacinacaoNotification({
    required String vacinacaoId,
    required String titulo,
    required String descricao,
    required String dataVacinacao,
    required String animalNome,
    required String animalId,
  }) async {
    print('💉 Agendando notificação de vacinação...');
    print('- ID: $vacinacaoId');
    print('- Título: $titulo');
    print('- Data: $dataVacinacao');
    print('- Animal: $animalNome');

    final DateTime? scheduledDate = _parseDataToDateTime(dataVacinacao);

    if (scheduledDate == null) {
      print('❌ Erro: Não foi possível fazer parse da data: $dataVacinacao');
      return;
    }

    print('📅 Data parseada: $scheduledDate');

    // Agendar para 00:00:01 do dia da vacinação
    final DateTime notificationTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      0, // hora
      0, // minuto
      1, // segundo
    );

    print('⏰ Horário da notificação: $notificationTime');

    if (notificationTime.isBefore(DateTime.now())) {
      print('⚠️ Data da vacinação já passou: $dataVacinacao');
      // Mesmo assim vamos salvar no banco para aparecer na lista
      await _saveScheduledNotificacao(
        type: 'vacinacao',
        title: '💉 Dia da vacinação!',
        body: '$titulo - $descricao para $animalNome',
        scheduledTime: notificationTime,
        relatedId: vacinacaoId,
        animalId: animalId,
      );
      print('💾 Notificação de vacinação expirada salva no banco');
      return;
    }

    await _scheduleVacinacaoNotification(
      vacinacaoId: vacinacaoId,
      titulo: titulo,
      descricao: descricao,
      animalNome: animalNome,
      animalId: animalId,
      notificationTime: notificationTime,
    );
  }

  Future<void> _scheduleVacinacaoNotification({
    required String vacinacaoId,
    required String titulo,
    required String descricao,
    required String animalNome,
    required String animalId,
    required DateTime notificationTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'vacinacao_channel',
      'Vacinação',
      channelDescription: 'Notificações de vacinação dos pets',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    AndroidScheduleMode scheduleMode = sdkInt >= 31
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.exact;

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        vacinacaoId.hashCode,
        '💉 Dia da vacinação!',
        '$titulo - $descricao para $animalNome',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'vacinacao_$vacinacaoId',
        matchDateTimeComponents: null,
      );

      print('✅ Notificação de vacinação agendada com sucesso!');
      print('🆔 ID da notificação: ${vacinacaoId.hashCode}');
      print('📅 Horário agendado: $scheduledDate');

    } catch (e) {
      print('❌ Erro ao agendar notificação de vacinação: $e');
    }

    // Salvar no banco como agendada (sem sentTime)
    await _saveScheduledNotificacao(
      type: 'vacinacao',
      title: '💉 Dia da vacinação!',
      body: '$titulo - $descricao para $animalNome',
      scheduledTime: notificationTime,
      relatedId: vacinacaoId,
      animalId: animalId,
    );

    print('💾 Notificação de vacinação salva no banco com related_id: $vacinacaoId');
  }

  // CONSULTA - IGUAL À VACINAÇÃO
  Future<void> scheduleConsultaNotification({
    required String consultaId,
    required String titulo,
    required String descricao,
    required String dataConsulta,
    required String animalNome,
    required String animalId,
  }) async {
    print('🏥 Agendando notificação de consulta...');
    print('- ID: $consultaId');
    print('- Título: $titulo');
    print('- Data: $dataConsulta');
    print('- Animal: $animalNome');

    final DateTime? scheduledDate = _parseDataToDateTime(dataConsulta);

    if (scheduledDate == null) {
      print('❌ Erro: Não foi possível fazer parse da data: $dataConsulta');
      return;
    }

    print('📅 Data parseada: $scheduledDate');

    // Agendar para 00:00:01 do dia da consulta
    final DateTime notificationTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      0, // hora
      0, // minuto
      1, // segundo
    );

    print('⏰ Horário da notificação: $notificationTime');

    if (notificationTime.isBefore(DateTime.now())) {
      print('⚠️ Data da consulta já passou: $dataConsulta');
      // Mesmo assim vamos salvar no banco para aparecer na lista
      await _saveScheduledNotificacao(
        type: 'consulta',
        title: '🏥 Dia da consulta!',
        body: '$titulo - $descricao para $animalNome',
        scheduledTime: notificationTime,
        relatedId: consultaId,
        animalId: animalId,
      );
      print('💾 Notificação de consulta expirada salva no banco');
      return;
    }

    await _scheduleConsultaNotification(
      consultaId: consultaId,
      titulo: titulo,
      descricao: descricao,
      animalNome: animalNome,
      animalId: animalId,
      notificationTime: notificationTime,
    );
  }

  Future<void> _scheduleConsultaNotification({
    required String consultaId,
    required String titulo,
    required String descricao,
    required String animalNome,
    required String animalId,
    required DateTime notificationTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'consulta_channel',
      'Consulta',
      channelDescription: 'Notificações de consulta dos pets',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    AndroidScheduleMode scheduleMode = sdkInt >= 31
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.exact;

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        consultaId.hashCode,
        '🏥 Dia da consulta!',
        '$titulo - $descricao para $animalNome',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'consulta_$consultaId',
        matchDateTimeComponents: null,
      );

      print('✅ Notificação de consulta agendada com sucesso!');
      print('🆔 ID da notificação: ${consultaId.hashCode}');
      print('📅 Horário agendado: $scheduledDate');

    } catch (e) {
      print('❌ Erro ao agendar notificação de consulta: $e');
    }

    // Salvar no banco como agendada (sem sentTime)
    await _saveScheduledNotificacao(
      type: 'consulta',
      title: '🏥 Dia da consulta!',
      body: '$titulo - $descricao para $animalNome',
      scheduledTime: notificationTime,
      relatedId: consultaId,
      animalId: animalId,
    );

    print('💾 Notificação de consulta salva no banco com related_id: $consultaId');
  }

  DateTime? _parseHorarioToDateTime(String horario) {
    try {
      final parts = horario.split(': ');
      if (parts.length != 2) return null;

      final timePart = parts[1];
      final timeComponents = timePart.split(':');
      if (timeComponents.length != 2) return null;

      final hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      final now = DateTime.now();
      DateTime scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      return scheduledTime;
    } catch (e) {
      return null;
    }
  }

  DateTime? _parseDataToDateTime(String data) {
    try {
      print('🔍 Fazendo parse da data: $data');

      // Assumindo formato dd/MM/yyyy
      final parts = data.split('/');
      if (parts.length != 3) {
        print('❌ Formato de data inválido: $data');
        return null;
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final parsedDate = DateTime(year, month, day);
      print('✅ Data parseada com sucesso: $parsedDate');

      return parsedDate;
    } catch (e) {
      print('❌ Erro ao fazer parse da data: $data - $e');
      return null;
    }
  }

  Future<void> testNotificationIn10Seconds() async {
    print('🧪 Agendando notificação de teste em 10 segundos...');

    final testTime = DateTime.now().add(const Duration(seconds: 10));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'test_channel',
      'Teste',
      channelDescription: 'Notificações de teste',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(testTime, tz.local);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    AndroidScheduleMode scheduleMode = sdkInt >= 31
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.exact;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      999,
      '🧪 Teste de Notificação',
      'Esta notificação foi agendada para testar o sistema!',
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'test_999',
    );

    // Salvar notificação de teste no banco
    final testNotificacao = NotificacoesModel(
      id: 'test_999',
      type: 'test',
      title: '🧪 Teste de Notificação',
      body: 'Esta notificação foi agendada para testar o sistema!',
      scheduledTime: testTime,
      relatedId: 'test_999',
      animalId: 'test',
      createdAt: DateTime.now(),
    );

    await _repository.save(testNotificacao);
    print('🧪 Notificação de teste salva no banco');
  }

  Future<void> testImmediateNotification() async {
    print('🧪 Enviando notificação imediata...');

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'immediate_test_channel',
      'Teste Imediato',
      channelDescription: 'Teste de notificação imediata',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      998,
      '🧪 Teste Imediato',
      'Esta é uma notificação imediata para testar!',
      platformChannelSpecifics,
      payload: 'immediate_998',
    );

    // Salvar no histórico como já enviada
    final testNotificacao = NotificacoesModel(
      id: 'immediate_998',
      type: 'test',
      title: '🧪 Teste Imediato',
      body: 'Esta é uma notificação imediata para testar!',
      scheduledTime: DateTime.now(),
      sentTime: DateTime.now(), // Marcar como já enviada
      relatedId: 'immediate_998',
      animalId: 'test',
      createdAt: DateTime.now(),
    );

    await _repository.save(testNotificacao);
    print('🧪 Notificação imediata salva no histórico');
  }

  Future<void> cancelAlimentacaoNotification(String alimentacaoId) async {
    await _flutterLocalNotificationsPlugin.cancel(alimentacaoId.hashCode);
    await _repository.deleteByRelatedId(alimentacaoId);
  }

  Future<void> cancelVacinacaoNotification(String vacinacaoId) async {
    await _flutterLocalNotificationsPlugin.cancel(vacinacaoId.hashCode);
    await _repository.deleteByRelatedId(vacinacaoId);
  }

  Future<void> cancelConsultaNotification(String consultaId) async {
    await _flutterLocalNotificationsPlugin.cancel(consultaId.hashCode);
    await _repository.deleteByRelatedId(consultaId);
  }

  Future<void> _saveScheduledNotificacao({
    required String type,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String relatedId,
    required String animalId,
  }) async {
    // Gerar um ID único para a notificação (diferente do ID da alimentação/vacinação/consulta)
    final notificacaoId = const Uuid().v4();

    final notificacao = NotificacoesModel(
      id: notificacaoId,  // ID único da notificação
      type: type,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      // sentTime: null, // Não definir sentTime - será definido quando a notificação for realmente enviada
      relatedId: relatedId,  // ID da alimentação/vacinação/consulta (relacionado)
      animalId: animalId,
      createdAt: DateTime.now(),
    );

    await _repository.save(notificacao);
    print('💾 Notificação salva: ID=${notificacao.id}, RelatedID=${notificacao.relatedId}, Type=${notificacao.type}');
  }

  Future<void> markNotificacaoAsSent(String id) async {
    await _repository.markAsSent(id);
  }
}

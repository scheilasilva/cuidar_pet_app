import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/notificacoes_model.dart';
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

    await _requestPermissions();
    await checkNotificationSettings(); // Chamada do método público
  }

  Future<void> _requestPermissions() async {
    print('🔐 Verificando permissões...');

    final notificationStatus = await Permission.notification.status;
    print('📋 Status da permissão de notificação: $notificationStatus');

    if (notificationStatus.isDenied) {
      final result = await Permission.notification.request();
      print('📋 Resultado da solicitação: $result');
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();
      print('⏰ Permissão de alarme exato: $result');
    }

    final batteryOptimization = await Permission.ignoreBatteryOptimizations.status;
    print('🔋 Otimização de bateria: $batteryOptimization');

    if (batteryOptimization.isDenied) {
      print('⚠️ Recomendado desabilitar otimização de bateria para o app');
    }
  }

  // MÉTODO PÚBLICO para verificar configurações
  Future<void> checkNotificationSettings() async {
    print('⚙️ Verificando configurações de notificação...');

    final bool? areNotificationsEnabled = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    print('🔔 Notificações habilitadas no sistema: $areNotificationsEnabled');

    await checkPendingNotifications();
  }

  // MÉTODO PÚBLICO para verificar notificações pendentes
  Future<void> checkPendingNotifications() async {
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('📋 Notificações pendentes: ${pendingNotifications.length}');

    for (var notification in pendingNotifications) {
      print('- ID: ${notification.id}, Título: ${notification.title}');
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('👆 Notificação tocada: ${notificationResponse.payload}');
  }

  Future<void> scheduleAlimentacaoNotification({
    required String alimentacaoId,
    required String titulo,
    required String alimento,
    required String horario,
    required String animalNome,
    required String animalId,
  }) async {
    print('🔔 Agendando notificação para: $horario');

    final DateTime? scheduledTime = _parseHorarioToDateTime(horario);

    if (scheduledTime == null) {
      print('❌ Erro: Não foi possível fazer parse do horário: $horario');
      return;
    }

    print('📅 Horário parseado: $scheduledTime');

    final DateTime notificationTime = scheduledTime.subtract(const Duration(minutes: 10));

    print('⏰ Notificação agendada para: $notificationTime');
    print('🌍 Timezone local: ${tz.local}');

    if (notificationTime.isBefore(DateTime.now())) {
      print('⚠️ Horário da notificação é no passado, agendando para o próximo dia');
      final tomorrow = notificationTime.add(const Duration(days: 1));
      await _scheduleNotification(
        alimentacaoId: alimentacaoId,
        titulo: titulo,
        alimento: alimento,
        animalNome: animalNome,
        animalId: animalId,
        notificationTime: tomorrow,
      );
      return;
    }

    await _scheduleNotification(
      alimentacaoId: alimentacaoId,
      titulo: titulo,
      alimento: alimento,
      animalNome: animalNome,
      animalId: animalId,
      notificationTime: notificationTime,
    );
  }

  Future<void> _scheduleNotification({
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
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

    print('📅 Data agendada (TZDateTime): $scheduledDate');
    print('🕐 Diferença para agora: ${scheduledDate.difference(tz.TZDateTime.now(tz.local))}');

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        alimentacaoId.hashCode,
        '🍽️ Hora da alimentação!',
        'Em 10 minutos: $titulo - $alimento para $animalNome',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'alimentacao_$alimentacaoId',
        matchDateTimeComponents: null,
      );

      print('✅ Notificação agendada com sucesso!');
      print('🆔 ID da notificação: ${alimentacaoId.hashCode}');

      await _verifyScheduledNotification(alimentacaoId.hashCode);

    } catch (e) {
      print('❌ Erro ao agendar notificação: $e');
    }

    await _saveScheduledNotificacao(
      id: alimentacaoId,
      type: 'alimentacao',
      title: '🍽️ Hora da alimentação!',
      body: 'Em 10 minutos: $titulo - $alimento para $animalNome',
      scheduledTime: notificationTime,
      relatedId: alimentacaoId,
      animalId: animalId,
    );

    print('📊 Timestamp salvo no banco: ${notificationTime.millisecondsSinceEpoch}');
  }

  Future<void> _verifyScheduledNotification(int notificationId) async {
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final found = pendingNotifications.any((n) => n.id == notificationId);

    if (found) {
      print('✅ Notificação confirmada na lista de pendentes');
    } else {
      print('❌ Notificação NÃO encontrada na lista de pendentes!');
    }
  }

  DateTime? _parseHorarioToDateTime(String horario) {
    try {
      print('🔍 Fazendo parse do horário: $horario');

      final parts = horario.split(': ');
      if (parts.length != 2) {
        print('❌ Formato inválido: esperado "Período: HH:MM"');
        return null;
      }

      final timePart = parts[1];
      final timeComponents = timePart.split(':');
      if (timeComponents.length != 2) {
        print('❌ Formato de hora inválido: esperado "HH:MM"');
        return null;
      }

      final hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      print('🕐 Hora extraída: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');

      final now = DateTime.now();
      DateTime scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

      print('📅 Data/hora criada: $scheduledTime');
      print('🕐 Agora: $now');

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
        print('➡️ Horário ajustado para amanhã: $scheduledTime');
      }

      return scheduledTime;
    } catch (e) {
      print('❌ Erro ao fazer parse do horário: $e');
      return null;
    }
  }

  // MÉTODO PÚBLICO para teste em 10 segundos
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

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      999,
      '🧪 Teste de Notificação',
      'Esta notificação foi agendada para testar o sistema!',
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('🧪 Notificação de teste agendada para: $testTime');
  }

  // MÉTODO PÚBLICO para notificação imediata
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
    );

    print('🧪 Notificação imediata enviada!');
  }

  Future<void> cancelAlimentacaoNotification(String alimentacaoId) async {
    await _flutterLocalNotificationsPlugin.cancel(alimentacaoId.hashCode);
    await _repository.deleteByRelatedId(alimentacaoId);
  }

  Future<void> _saveScheduledNotificacao({
    required String id,
    required String type,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String relatedId,
    required String animalId,
  }) async {
    final notificacao = NotificacoesModel(
      id: id,
      type: type,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      relatedId: relatedId,
      animalId: animalId,
      createdAt: DateTime.now(),
    );

    await _repository.save(notificacao);
  }

  Future<void> markNotificacaoAsSent(String id) async {
    await _repository.markAsSent(id);
  }
}

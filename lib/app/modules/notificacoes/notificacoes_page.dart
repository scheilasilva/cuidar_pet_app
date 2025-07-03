import 'package:cuidar_pet_app/app/modules/notificacoes/repositories/notificacoes_repository.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'models/notificacoes_model.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final NotificacoesRepository _repository = NotificacoesRepository();
  List<NotificacoesModel> notificacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificacoes();
  }

  Future<void> _loadNotificacoes() async {
    try {
      print('🔄 Carregando notificações...');

      final loadedNotificacoes = await _repository.getAll();

      setState(() {
        notificacoes = loadedNotificacoes;
        isLoading = false;
      });

      print('✅ ${notificacoes.length} notificações carregadas');

      for (var notif in notificacoes) {
        print('- ID: ${notif.id}');
        print('  RelatedID: ${notif.relatedId}');
        print('  Título: ${notif.title}');
        print('  Agendada: ${notif.scheduledTime}');
        print('  Enviada: ${notif.sentTime}');
        print('  Status: ${notif.sentTime != null ? "ENVIADA" : "AGENDADA"}');
        print('---');
      }
    } catch (e) {
      print('❌ Erro ao carregar notificações: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(NotificacoesModel notificacao) async {
    if (!notificacao.isRead) {
      await _repository.markAsRead(notificacao.id);
      setState(() {
        notificacao.isRead = true;
      });
    }
  }

  String _getNotificacaoTitle(String type) {
    switch (type) {
      case 'alimentacao':
        return 'Alimentação';
      case 'vacinacao':
        return 'Vacinação';
      case 'exame':
        return 'Exame';
      case 'tratamento':
        return 'Tratamento';
      case 'consulta':
        return 'Consulta';
      case 'test':
        return 'Teste';
      default:
        return 'Notificação';
    }
  }

  IconData _getNotificacaoIconData(String type) {
    switch (type) {
      case 'alimentacao':
        return Icons.restaurant;
      case 'vacinacao':
        return Icons.vaccines;
      case 'exame':
        return Icons.science;
      case 'tratamento':
        return Icons.medication;
      case 'consulta':
        return Icons.event_available;
      case 'test':
        return Icons.bug_report;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimeRemaining(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return 'Expirada';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}min';
    } else {
      return '${difference.inDays} dias';
    }
  }

  Widget _buildNotificationCard(NotificacoesModel notificacao) {
    final bool isScheduled = notificacao.sentTime == null;
    final bool isExpired = isScheduled && notificacao.scheduledTime.isBefore(DateTime.now());

    String subtitle = notificacao.body;
    if (notificacao.type == 'alimentacao' && notificacao.body.contains(' - ')) {
      final parts = notificacao.body.split(' - ');
      if (parts.length >= 2) {
        subtitle = parts[1].split(' para ')[0];
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _markAsRead(notificacao),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00845A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificacaoIconData(notificacao.type),
                    color: const Color(0xFF00845A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getNotificacaoTitle(notificacao.type),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isScheduled
                            ? (isExpired ? Colors.red : Colors.orange)
                            : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isScheduled
                            ? (isExpired ? 'EXPIRADA' : 'AGENDADA')
                            : 'ENVIADA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isScheduled && !isExpired)
                      Text(
                        _formatTimeRemaining(notificacao.scheduledTime),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (!notificacao.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00845A),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        centerTitle: true,
        title: const Text(
          'Notificações',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00845A),
              size: 24,
            ),
            onPressed: () {
              Modular.to.navigate('/$homeRoute');
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Últimas notificações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : notificacoes.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 64,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma notificação ainda',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'As notificações aparecerão aqui quando forem agendadas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: notificacoes.length,
                itemBuilder: (context, index) {
                  final notificacao = notificacoes[index];
                  return _buildNotificationCard(notificacao);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

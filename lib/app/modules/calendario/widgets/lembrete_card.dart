import 'package:cuidar_pet_app/app/modules/calendario/lembrete/store/lembrete_store.dart';
import 'package:flutter/material.dart';

class LembreteCard extends StatelessWidget {
  final LembreteStore lembrete;
  final Function(bool) onToggleConcluido;

  const LembreteCard({
    super.key,
    required this.lembrete,
    required this.onToggleConcluido,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Ícone da categoria
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lembrete.corCategoria,
                shape: BoxShape.circle,
              ),
              child: Icon(
                lembrete.iconeCategoria,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Informações do lembrete
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lembrete.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lembrete.dataLembrete.day.toString().padLeft(2, '0')}/${lembrete.dataLembrete.month.toString().padLeft(2, '0')}/${lembrete.dataLembrete.year}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Indicador de dias e status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lembrete.diasDesdeCreacao == 0
                      ? 'hoje'
                      : 'há ${lembrete.diasDesdeCreacao} dias',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => onToggleConcluido(!lembrete.concluido),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: lembrete.concluido
                          ? const Color(0xFF00845A)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: lembrete.concluido
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

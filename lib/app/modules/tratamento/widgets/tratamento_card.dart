import 'package:flutter/material.dart';
import '../store/tratamento_store.dart';

class TratamentoCard extends StatelessWidget {
  final TratamentoStore tratamento;
  final VoidCallback onTap;
  final Function(bool?) onCheckboxChanged;

  const TratamentoCard({
    super.key,
    required this.tratamento,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox para marcar como concluído
            Checkbox(
              value: tratamento.concluido,
              onChanged: onCheckboxChanged,
              activeColor: const Color(0xFF00845A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 12),

            // Ícone do tratamento
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tratamento.concluido
                    ? Colors.grey[400]
                    : const Color(0xFF00845A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Informações do tratamento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e data na mesma linha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          tratamento.titulo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tratamento.concluido
                                ? Colors.grey[600]
                                : Colors.black87,
                            decoration: tratamento.concluido
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            tratamento.dataInicio,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: tratamento.concluido
                                  ? Colors.grey[400]
                                  : const Color(0xFF00845A),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tipo de tratamento
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tratamento.concluido
                          ? Colors.grey[200]
                          : const Color(0xFF00845A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tratamento.tipo,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tratamento.concluido
                            ? Colors.grey[600]
                            : const Color(0xFF00845A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Descrição
                  Text(
                    tratamento.descricao,
                    style: TextStyle(
                      fontSize: 14,
                      color: tratamento.concluido
                          ? Colors.grey[500]
                          : Colors.grey[700],
                      height: 1.4,
                      decoration: tratamento.concluido
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
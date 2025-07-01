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
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Seção verde com ícone apenas
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: tratamento.concluido
                    ? Colors.grey[400]
                    : const Color(0xFF00845A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e data na mesma linha (igual ao ExameCard)
                    Row(
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
                        Row(
                          children: [
                            Text(
                              tratamento.dataInicio,
                              style: TextStyle(
                                fontSize: 14,
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

                    const SizedBox(height: 3),

                    // Descrição e checkbox
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
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
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                              value: tratamento.concluido,
                              onChanged: onCheckboxChanged,
                              activeColor: const Color(0xFF00845A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../store/vacinacao_store.dart';

class VacinacaoCard extends StatelessWidget {
  final VacinacaoStore vacinacao;
  final VoidCallback onTap;

  const VacinacaoCard({
    super.key,
    required this.vacinacao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // Ícone de seringa
            Container(
              width: 60,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vaccines,
                    color: const Color(0xFF00845A),
                    size: 28,
                  ),
                  SizedBox(height: 4),
                  Icon(
                    Icons.medication_liquid,
                    color: const Color(0xFF00845A),
                    size: 28,
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Título da vacina
                    Expanded(
                      child: Text(
                        vacinacao.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Data e status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Data
                        Row(
                          children: [
                            Text(
                              vacinacao.dataVacinacao,
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
                                color: const Color(0xFF00845A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Tag de status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(vacinacao.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            vacinacao.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Concluída':
        return const Color(0xFF00C853); // Verde
      case 'Atrasada':
        return const Color(0xFFFF3D00); // Vermelho
      case 'Em andamento':
      default:
        return const Color(0xFFFFD600); // Amarelo
    }
  }
}

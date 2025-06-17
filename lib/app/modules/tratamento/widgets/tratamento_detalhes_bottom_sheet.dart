import 'package:flutter/material.dart';
import 'dart:io';
import '../store/tratamento_store.dart';

class TratamentoDetalhesBottomSheet extends StatelessWidget {
  final TratamentoStore tratamento;
  final VoidCallback onDelete;
  final Function(bool) onToggleConcluido;

  const TratamentoDetalhesBottomSheet({
    super.key,
    required this.tratamento,
    required this.onDelete,
    required this.onToggleConcluido,
  });

  Widget _buildImageSection() {
    if (tratamento.imagem != null && tratamento.imagem!.isNotEmpty) {
      final file = File(tratamento.imagem!);
      if (file.existsSync()) {
        return Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhuma imagem',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle do bottom sheet
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Conteúdo scrollável
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status e título
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: tratamento.concluido
                                  ? Colors.green.withOpacity(0.1)
                                  : const Color(0xFF00845A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tratamento.concluido ? 'Concluído' : 'Em andamento',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: tratamento.concluido
                                    ? Colors.green[700]
                                    : const Color(0xFF00845A),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Título do tratamento
                      Text(
                        tratamento.titulo,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: tratamento.concluido
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tipo de tratamento
                      Text(
                        'Tipo de tratamento: ${tratamento.tipo}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00845A),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Data
                      Text(
                        'Data de início: ${tratamento.dataInicio}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Descrição
                      Text(
                        tratamento.descricao,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                          decoration: tratamento.concluido
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Seção de imagem
                      _buildImageSection(),

                      const SizedBox(height: 32),

                      // Botão para marcar/desmarcar como concluído
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onToggleConcluido(!tratamento.concluido);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tratamento.concluido
                                ? Colors.orange
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            tratamento.concluido
                                ? 'Marcar como em andamento'
                                : 'Marcar como concluído',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botão Deletar
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Deletar tratamento',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Tem certeza que deseja excluir o tratamento "${tratamento.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
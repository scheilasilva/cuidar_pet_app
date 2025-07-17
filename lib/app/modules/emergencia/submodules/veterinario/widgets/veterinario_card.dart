import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/veterinario_model.dart';

class VeterinarioCard extends StatelessWidget {
  final VeterinarioModel veterinario;
  final VoidCallback? onTap;

  const VeterinarioCard({
    super.key,
    required this.veterinario,
    this.onTap,
  });

  Future<void> _ligarVeterinario() async {
    if (veterinario.telefone != null && veterinario.telefone!.isNotEmpty) {
      try {
        // Limpar o telefone removendo caracteres especiais
        final telefoneNumeros = veterinario.telefone!.replaceAll(RegExp(r'[^\d+]'), '');
        final uri = Uri.parse('tel:$telefoneNumeros');

        print('📞 Tentando ligar para: $telefoneNumeros');

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          print('❌ Não foi possível abrir o discador');
          _mostrarErro('Não foi possível abrir o discador do telefone');
        }
      } catch (e) {
        print('❌ Erro ao tentar ligar: $e');
        _mostrarErro('Erro ao tentar fazer a ligação');
      }
    } else {
      _mostrarErro('Telefone não disponível');
    }
  }

  Future<void> _abrirNavegacao() async {
    try {
      // Usar Google Maps com coordenadas para maior precisão
      final uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=${veterinario.latitude},${veterinario.longitude}&travelmode=driving'
      );

      print('🗺️ Abrindo navegação para: ${veterinario.nome}');
      print('📍 Coordenadas: ${veterinario.latitude}, ${veterinario.longitude}');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: tentar abrir o app do Google Maps diretamente
        final googleMapsUri = Uri.parse(
            'google.navigation:q=${veterinario.latitude},${veterinario.longitude}&mode=d'
        );

        if (await canLaunchUrl(googleMapsUri)) {
          await launchUrl(googleMapsUri);
        } else {
          print('❌ Não foi possível abrir o Google Maps');
          _mostrarErro('Não foi possível abrir o Google Maps');
        }
      }
    } catch (e) {
      print('❌ Erro ao abrir navegação: $e');
      _mostrarErro('Erro ao abrir navegação');
    }
  }

  void _mostrarErro(String mensagem) {
    // Você pode implementar um snackbar ou toast aqui
    print('⚠️ $mensagem');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e distância
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00845A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Informações principais
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome e badge 24h
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                veterinario.nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (veterinario.emergencia24h)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '24h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Distância e avaliação
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              veterinario.distanciaFormatada,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (veterinario.avaliacao != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber[600],
                              ),
                              const SizedBox(width: 2),
                              Text(
                                veterinario.avaliacao!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Endereço
              Text(
                veterinario.endereco,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Telefone (se disponível)
              if (veterinario.telefone != null && veterinario.telefone!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      veterinario.telefone!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              // Horário de funcionamento
              if (veterinario.horarioFuncionamento != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        veterinario.horarioFuncionamento!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Botões de ação
              Row(
                children: [
                  // Botão Ligar
                  if (veterinario.telefone != null && veterinario.telefone!.isNotEmpty)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _ligarVeterinario,
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Ligar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00845A),
                          side: const BorderSide(color: Color(0xFF00845A)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                  if (veterinario.telefone != null && veterinario.telefone!.isNotEmpty)
                    const SizedBox(width: 8),

                  // Botão Navegar
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _abrirNavegacao,
                      icon: const Icon(Icons.directions, size: 16),
                      label: const Text('Navegar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00845A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

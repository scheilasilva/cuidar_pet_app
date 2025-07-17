class VeterinarioModel {
  final String id;
  final String nome;
  final String endereco;
  final double latitude;
  final double longitude;
  final String? telefone;
  final String? horarioFuncionamento;
  final double? avaliacao;
  final bool emergencia24h;
  final double distancia; // em km

  VeterinarioModel({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.telefone,
    this.horarioFuncionamento,
    this.avaliacao,
    this.emergencia24h = false,
    this.distancia = 0.0,
  });

  String get distanciaFormatada {
    if (distancia < 1) {
      return '${(distancia * 1000).round()}m';
    }
    return '${distancia.toStringAsFixed(1)}km';
  }

  String get avaliacaoFormatada {
    if (avaliacao == null) return 'Sem avaliação';
    return avaliacao!.toStringAsFixed(1);
  }

  String get statusFuncionamento {
    if (emergencia24h) return 'Aberto 24h';
    if (horarioFuncionamento != null) return horarioFuncionamento!;
    return 'Horário não informado';
  }
}

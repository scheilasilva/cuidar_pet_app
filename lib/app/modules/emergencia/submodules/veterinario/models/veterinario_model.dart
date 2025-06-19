import 'dart:math' as math;

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

  factory VeterinarioModel.fromJson(Map<String, dynamic> json, double userLat, double userLng) {
    final lat = json['geometry']['coordinates'][1].toDouble();
    final lng = json['geometry']['coordinates'][0].toDouble();

    return VeterinarioModel(
      id: json['id'] ?? '',
      nome: json['properties']['name'] ?? 'Veterinário',
      endereco: json['properties']['address'] ?? 'Endereço não disponível',
      latitude: lat,
      longitude: lng,
      telefone: json['properties']['phone'],
      horarioFuncionamento: json['properties']['opening_hours'],
      avaliacao: json['properties']['rating']?.toDouble(),
      emergencia24h: json['properties']['opening_hours']?.toString().contains('24') ?? false,
      distancia: _calcularDistancia(userLat, userLng, lat, lng),
    );
  }

  static double _calcularDistancia(double lat1, double lng1, double lat2, double lng2) {
    // Fórmula de Haversine para calcular distância entre dois pontos
    const double earthRadius = 6371; // Raio da Terra em km

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(lat1 * (math.pi / 180)) * math.cos(lat2 * (math.pi / 180)) *
                math.sin(dLng / 2) * math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  String get distanciaFormatada {
    if (distancia < 1) {
      return '${(distancia * 1000).round()}m';
    }
    return '${distancia.toStringAsFixed(1)}km';
  }
}
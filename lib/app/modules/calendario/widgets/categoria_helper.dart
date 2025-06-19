import 'package:flutter/material.dart';

class CategoriaHelper {
  static const Map<String, Map<String, dynamic>> categorias = {
    'saude': {
      'nome': 'Saúde',
      'cor': Color(0xFFFF6B6B), // Vermelho
      'icone': Icons.medical_services,
    },
    'alimentacao': {
      'nome': 'Alimentação',
      'cor': Color(0xFF9B59B6), // Roxo
      'icone': Icons.restaurant,
    },
    'exercicio': {
      'nome': 'Exercício',
      'cor': Color(0xFFF1C40F), // Amarelo
      'icone': Icons.fitness_center,
    },
    'cuidados': {
      'nome': 'Cuidados',
      'cor': Color(0xFFE91E63), // Rosa
      'icone': Icons.pets,
    },
  };

  static Color getCorCategoria(String categoria) {
    return categorias[categoria]?['cor'] ?? Colors.grey;
  }

  static IconData getIconeCategoria(String categoria) {
    return categorias[categoria]?['icone'] ?? Icons.help;
  }

  static String getNomeCategoria(String categoria) {
    return categorias[categoria]?['nome'] ?? 'Outros';
  }

  static List<String> getTodasCategorias() {
    return categorias.keys.toList();
  }
}

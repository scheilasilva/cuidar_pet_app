import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../models/vacinacao_model.dart';

part 'vacinacao_store.g.dart';

class VacinacaoStore = _VacinacaoStoreBase with _$VacinacaoStore;

abstract class VacinacaoStoreFactory {
  static VacinacaoStore fromModel(VacinacaoModel model) => VacinacaoStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    descricao: model.descricao,
    dataVacinacao: model.dataVacinacao,
    tipo: model.tipo,
    imagem: model.imagem,
    concluida: model.concluida,
    createdAt: model.createdAt,
  );

  static VacinacaoStore novo(String animalId) => VacinacaoStore(
    id: '',
    animalId: animalId,
    titulo: '',
    descricao: '',
    dataVacinacao: '',
    tipo: '',
    imagem: null,
    concluida: false,
    createdAt: DateTime.now(),
  );
}

abstract class _VacinacaoStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String descricao;

  @observable
  String dataVacinacao;

  @observable
  String tipo;

  @observable
  String? imagem;

  @observable
  bool concluida;

  @observable
  DateTime createdAt;

  _VacinacaoStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataVacinacao,
    required this.tipo,
    this.imagem,
    required this.concluida,
    required this.createdAt,
  });

  // ✅ Validação corrigida - apenas campos obrigatórios
  @computed
  bool get isFormValid {
    return titulo.trim().isNotEmpty &&
        descricao.trim().isNotEmpty &&
        dataVacinacao.trim().isNotEmpty &&
        animalId.trim().isNotEmpty;
    // ✅ Imagem NÃO é obrigatória
  }

  // ✅ Métodos para atualizar campos individualmente
  @action
  void setTitulo(String value) {
    titulo = value;
  }

  @action
  void setDescricao(String value) {
    descricao = value;
  }

  @action
  void setDataVacinacao(String value) {
    dataVacinacao = value;
  }

  @action
  void setImagem(String? value) {
    imagem = value;
  }

  @action
  void setConcluida(bool value) {
    concluida = value;
  }

  VacinacaoModel toModel() {
    return VacinacaoModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      descricao: descricao,
      dataVacinacao: dataVacinacao,
      tipo: tipo,
      imagem: imagem, // ✅ Pode ser null
      concluida: concluida,
      createdAt: createdAt,
    );
  }

  // Método para verificar o status da vacinação
  String get status {
    if (concluida) {
      return 'Concluída';
    }

    // Converter a data da vacinação para DateTime
    final dataFormatada = _converterStringParaData(dataVacinacao);
    if (dataFormatada == null) {
      return 'Em andamento'; // Fallback se a data for inválida
    }

    // Verificar se a data já passou
    if (DateTime.now().isAfter(dataFormatada)) {
      return 'Atrasada';
    }

    return 'Em andamento';
  }

  // Método auxiliar para converter string de data para DateTime
  DateTime? _converterStringParaData(String data) {
    try {
      // Assumindo formato dd/MM/yyyy
      final partes = data.split('/');
      if (partes.length == 3) {
        return DateTime(
          int.parse(partes[2]), // ano
          int.parse(partes[1]), // mês
          int.parse(partes[0]), // dia
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Cores para os status
  Color get statusColor {
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

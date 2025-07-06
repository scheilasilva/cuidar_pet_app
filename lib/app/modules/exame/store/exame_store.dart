import 'package:mobx/mobx.dart';
import '../models/exame_model.dart';

part 'exame_store.g.dart';

class ExameStore = _ExameStoreBase with _$ExameStore;

abstract class ExameStoreFactory {
  static ExameStore fromModel(ExameModel model) => ExameStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    descricao: model.descricao,
    dataRealizacao: model.dataRealizacao,
    tipo: model.tipo,
    imagem: model.imagem,
    createdAt: model.createdAt,
  );

  static ExameStore novo(String animalId) => ExameStore(
    id: '',
    animalId: animalId,
    titulo: '',
    descricao: '',
    dataRealizacao: '',
    tipo: '',
    imagem: null,
    createdAt: DateTime.now(),
  );
}

abstract class _ExameStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String descricao;

  @observable
  String dataRealizacao;

  @observable
  String tipo;

  @observable
  String? imagem;

  @observable
  DateTime createdAt;

  _ExameStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataRealizacao,
    required this.tipo,
    this.imagem,
    required this.createdAt,
  });

  // ✅ Validação corrigida - apenas campos obrigatórios
  @computed
  bool get isFormValid {
    return titulo.trim().isNotEmpty &&
        descricao.trim().isNotEmpty &&
        dataRealizacao.trim().isNotEmpty &&
        animalId.trim().isNotEmpty;
    // ✅ Imagem NÃO é obrigatória
  }

  // ✅ Método para atualizar campos individualmente
  @action
  void setTitulo(String value) {
    titulo = value;
  }

  @action
  void setDescricao(String value) {
    descricao = value;
  }

  @action
  void setDataRealizacao(String value) {
    dataRealizacao = value;
  }

  @action
  void setImagem(String? value) {
    imagem = value;
  }

  ExameModel toModel() {
    return ExameModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      descricao: descricao,
      dataRealizacao: dataRealizacao,
      tipo: tipo,
      imagem: imagem, // ✅ Pode ser null
      createdAt: createdAt,
    );
  }
}

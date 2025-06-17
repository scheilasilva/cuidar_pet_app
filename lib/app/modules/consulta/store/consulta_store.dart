import 'package:mobx/mobx.dart';
import '../models/consulta_model.dart';

part 'consulta_store.g.dart';

class ConsultaStore = _ConsultaStoreBase with _$ConsultaStore;

abstract class ConsultaStoreFactory {
  static ConsultaStore fromModel(ConsultaModel model) => ConsultaStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    descricao: model.descricao,
    dataConsulta: model.dataConsulta,
    tipo: model.tipo,
    imagem: model.imagem,
    createdAt: model.createdAt,
  );

  static ConsultaStore novo(String animalId) => ConsultaStore(
    id: '',
    animalId: animalId,
    titulo: '',
    descricao: '',
    dataConsulta: '',
    tipo: '',
    imagem: null,
    createdAt: DateTime.now(),
  );
}

abstract class _ConsultaStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String descricao;

  @observable
  String dataConsulta;

  @observable
  String tipo;

  @observable
  String? imagem;

  @observable
  DateTime createdAt;

  _ConsultaStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataConsulta,
    required this.tipo,
    this.imagem,
    required this.createdAt,
  });

  ConsultaModel toModel() {
    return ConsultaModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      descricao: descricao,
      dataConsulta: dataConsulta,
      tipo: tipo,
      imagem: imagem,
      createdAt: createdAt,
    );
  }
}

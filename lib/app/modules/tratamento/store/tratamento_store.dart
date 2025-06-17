import 'package:mobx/mobx.dart';
import '../models/tratamento_model.dart';

part 'tratamento_store.g.dart';

class TratamentoStore = _TratamentoStoreBase with _$TratamentoStore;

abstract class TratamentoStoreFactory {
  static TratamentoStore fromModel(TratamentoModel model) => TratamentoStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    descricao: model.descricao,
    dataInicio: model.dataInicio,
    tipo: model.tipo,
    imagem: model.imagem,
    concluido: model.concluido,
    createdAt: model.createdAt,
  );

  static TratamentoStore novo(String animalId) => TratamentoStore(
    id: '',
    animalId: animalId,
    titulo: '',
    descricao: '',
    dataInicio: '',
    tipo: '',
    imagem: null,
    concluido: false,
    createdAt: DateTime.now(),
  );
}

abstract class _TratamentoStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String descricao;

  @observable
  String dataInicio;

  @observable
  String tipo;

  @observable
  String? imagem;

  @observable
  bool concluido;

  @observable
  DateTime createdAt;

  _TratamentoStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataInicio,
    required this.tipo,
    this.imagem,
    required this.concluido,
    required this.createdAt,
  });

  TratamentoModel toModel() {
    return TratamentoModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      descricao: descricao,
      dataInicio: dataInicio,
      tipo: tipo,
      imagem: imagem,
      concluido: concluido,
      createdAt: createdAt,
    );
  }
}
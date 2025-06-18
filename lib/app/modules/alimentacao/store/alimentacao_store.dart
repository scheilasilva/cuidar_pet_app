import 'package:mobx/mobx.dart';
import '../models/alimentacao_model.dart';

part 'alimentacao_store.g.dart';

class AlimentacaoStore = _AlimentacaoStoreBase with _$AlimentacaoStore;

abstract class AlimentacaoStoreFactory {
  static AlimentacaoStore fromModel(AlimentacaoModel model) => AlimentacaoStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    horario: model.horario,
    alimento: model.alimento,
    observacao: model.observacao,
    createdAt: model.createdAt,
  );

  static AlimentacaoStore novo(String animalId) => AlimentacaoStore(
    id: '',
    animalId: animalId,
    titulo: '',
    horario: '',
    alimento: '',
    observacao: '',
    createdAt: DateTime.now(),
  );
}

abstract class _AlimentacaoStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String horario;

  @observable
  String alimento;

  @observable
  String observacao;

  @observable
  DateTime createdAt;

  _AlimentacaoStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.horario,
    required this.alimento,
    required this.observacao,
    required this.createdAt,
  });

  AlimentacaoModel toModel() {
    return AlimentacaoModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      horario: horario,
      alimento: alimento,
      observacao: observacao,
      createdAt: createdAt,
    );
  }
}

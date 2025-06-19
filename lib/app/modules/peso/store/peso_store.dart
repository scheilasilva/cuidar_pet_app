import 'package:mobx/mobx.dart';
import '../models/peso_model.dart';

part 'peso_store.g.dart';

class PesoStore = _PesoStoreBase with _$PesoStore;

abstract class PesoStoreFactory {
  static PesoStore fromModel(PesoModel model) => PesoStore(
    id: model.id,
    animalId: model.animalId,
    peso: model.peso,
    dataPesagem: model.dataPesagem,
    observacao: model.observacao,
    createdAt: model.createdAt,
  );

  static PesoStore novo(String animalId) => PesoStore(
    id: '',
    animalId: animalId,
    peso: 0.0,
    dataPesagem: DateTime.now(),
    observacao: null,
    createdAt: DateTime.now(),
  );
}

abstract class _PesoStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  double peso;

  @observable
  DateTime dataPesagem;

  @observable
  String? observacao;

  @observable
  DateTime createdAt;

  _PesoStoreBase({
    required this.id,
    required this.animalId,
    required this.peso,
    required this.dataPesagem,
    this.observacao,
    required this.createdAt,
  });

  PesoModel toModel() {
    return PesoModel(
      id: id,
      animalId: animalId,
      peso: peso,
      dataPesagem: dataPesagem,
      observacao: observacao,
      createdAt: createdAt,
    );
  }

  // Formatação da data para exibição
  String get dataFormatada {
    return '${dataPesagem.day.toString().padLeft(2, '0')}/${dataPesagem.month.toString().padLeft(2, '0')}/${dataPesagem.year}';
  }

  // Formatação do peso para exibição
  String get pesoFormatado {
    return '${peso.toStringAsFixed(1)} KG';
  }
}

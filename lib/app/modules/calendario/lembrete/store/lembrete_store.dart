import 'package:cuidar_pet_app/app/modules/calendario/widgets/categoria_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../models/lembrete_model.dart';

part 'lembrete_store.g.dart';

class LembreteStore = _LembreteStoreBase with _$LembreteStore;

abstract class LembreteStoreFactory {
  static LembreteStore fromModel(LembreteModel model) => LembreteStore(
    id: model.id,
    animalId: model.animalId,
    titulo: model.titulo,
    descricao: model.descricao,
    dataLembrete: model.dataLembrete,
    categoria: model.categoria,
    concluido: model.concluido,
    createdAt: model.createdAt,
  );

  static LembreteStore novo(String animalId, DateTime dataLembrete) => LembreteStore(
    id: '',
    animalId: animalId,
    titulo: '',
    descricao: '',
    dataLembrete: dataLembrete,
    categoria: '',
    concluido: false,
    createdAt: DateTime.now(),
  );
}

abstract class _LembreteStoreBase with Store {
  @observable
  String id;

  @observable
  String animalId;

  @observable
  String titulo;

  @observable
  String descricao;

  @observable
  DateTime dataLembrete;

  @observable
  String categoria;

  @observable
  bool concluido;

  @observable
  DateTime createdAt;

  _LembreteStoreBase({
    required this.id,
    required this.animalId,
    required this.titulo,
    required this.descricao,
    required this.dataLembrete,
    required this.categoria,
    required this.concluido,
    required this.createdAt,
  });

  LembreteModel toModel() {
    return LembreteModel(
      id: id,
      animalId: animalId,
      titulo: titulo,
      descricao: descricao,
      dataLembrete: dataLembrete,
      categoria: categoria,
      concluido: concluido,
      createdAt: createdAt,
    );
  }

  // Getters para categoria
  Color get corCategoria => CategoriaHelper.getCorCategoria(categoria);
  IconData get iconeCategoria => CategoriaHelper.getIconeCategoria(categoria);
  String get nomeCategoria => CategoriaHelper.getNomeCategoria(categoria);

  // Calcular dias desde a criação
  int get diasDesdeCreacao {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataLembrete);
    return diferenca.inDays.abs();
  }
}

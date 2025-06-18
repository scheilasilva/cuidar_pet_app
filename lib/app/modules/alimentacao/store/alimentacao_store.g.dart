// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimentacao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AlimentacaoStore on _AlimentacaoStoreBase, Store {
  late final _$idAtom =
      Atom(name: '_AlimentacaoStoreBase.id', context: context);

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$animalIdAtom =
      Atom(name: '_AlimentacaoStoreBase.animalId', context: context);

  @override
  String get animalId {
    _$animalIdAtom.reportRead();
    return super.animalId;
  }

  @override
  set animalId(String value) {
    _$animalIdAtom.reportWrite(value, super.animalId, () {
      super.animalId = value;
    });
  }

  late final _$tituloAtom =
      Atom(name: '_AlimentacaoStoreBase.titulo', context: context);

  @override
  String get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  late final _$horarioAtom =
      Atom(name: '_AlimentacaoStoreBase.horario', context: context);

  @override
  String get horario {
    _$horarioAtom.reportRead();
    return super.horario;
  }

  @override
  set horario(String value) {
    _$horarioAtom.reportWrite(value, super.horario, () {
      super.horario = value;
    });
  }

  late final _$alimentoAtom =
      Atom(name: '_AlimentacaoStoreBase.alimento', context: context);

  @override
  String get alimento {
    _$alimentoAtom.reportRead();
    return super.alimento;
  }

  @override
  set alimento(String value) {
    _$alimentoAtom.reportWrite(value, super.alimento, () {
      super.alimento = value;
    });
  }

  late final _$observacaoAtom =
      Atom(name: '_AlimentacaoStoreBase.observacao', context: context);

  @override
  String get observacao {
    _$observacaoAtom.reportRead();
    return super.observacao;
  }

  @override
  set observacao(String value) {
    _$observacaoAtom.reportWrite(value, super.observacao, () {
      super.observacao = value;
    });
  }

  late final _$createdAtAtom =
      Atom(name: '_AlimentacaoStoreBase.createdAt', context: context);

  @override
  DateTime get createdAt {
    _$createdAtAtom.reportRead();
    return super.createdAt;
  }

  @override
  set createdAt(DateTime value) {
    _$createdAtAtom.reportWrite(value, super.createdAt, () {
      super.createdAt = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
animalId: ${animalId},
titulo: ${titulo},
horario: ${horario},
alimento: ${alimento},
observacao: ${observacao},
createdAt: ${createdAt}
    ''';
  }
}

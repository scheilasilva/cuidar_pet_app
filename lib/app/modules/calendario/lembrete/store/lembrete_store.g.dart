// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lembrete_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LembreteStore on _LembreteStoreBase, Store {
  late final _$idAtom = Atom(name: '_LembreteStoreBase.id', context: context);

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
      Atom(name: '_LembreteStoreBase.animalId', context: context);

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
      Atom(name: '_LembreteStoreBase.titulo', context: context);

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

  late final _$descricaoAtom =
      Atom(name: '_LembreteStoreBase.descricao', context: context);

  @override
  String get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  late final _$dataLembreteAtom =
      Atom(name: '_LembreteStoreBase.dataLembrete', context: context);

  @override
  DateTime get dataLembrete {
    _$dataLembreteAtom.reportRead();
    return super.dataLembrete;
  }

  @override
  set dataLembrete(DateTime value) {
    _$dataLembreteAtom.reportWrite(value, super.dataLembrete, () {
      super.dataLembrete = value;
    });
  }

  late final _$categoriaAtom =
      Atom(name: '_LembreteStoreBase.categoria', context: context);

  @override
  String get categoria {
    _$categoriaAtom.reportRead();
    return super.categoria;
  }

  @override
  set categoria(String value) {
    _$categoriaAtom.reportWrite(value, super.categoria, () {
      super.categoria = value;
    });
  }

  late final _$concluidoAtom =
      Atom(name: '_LembreteStoreBase.concluido', context: context);

  @override
  bool get concluido {
    _$concluidoAtom.reportRead();
    return super.concluido;
  }

  @override
  set concluido(bool value) {
    _$concluidoAtom.reportWrite(value, super.concluido, () {
      super.concluido = value;
    });
  }

  late final _$createdAtAtom =
      Atom(name: '_LembreteStoreBase.createdAt', context: context);

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
descricao: ${descricao},
dataLembrete: ${dataLembrete},
categoria: ${categoria},
concluido: ${concluido},
createdAt: ${createdAt}
    ''';
  }
}

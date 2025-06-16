// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exame_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExameStore on _ExameStoreBase, Store {
  late final _$idAtom = Atom(name: '_ExameStoreBase.id', context: context);

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
      Atom(name: '_ExameStoreBase.animalId', context: context);

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
      Atom(name: '_ExameStoreBase.titulo', context: context);

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
      Atom(name: '_ExameStoreBase.descricao', context: context);

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

  late final _$dataRealizacaoAtom =
      Atom(name: '_ExameStoreBase.dataRealizacao', context: context);

  @override
  String get dataRealizacao {
    _$dataRealizacaoAtom.reportRead();
    return super.dataRealizacao;
  }

  @override
  set dataRealizacao(String value) {
    _$dataRealizacaoAtom.reportWrite(value, super.dataRealizacao, () {
      super.dataRealizacao = value;
    });
  }

  late final _$tipoAtom = Atom(name: '_ExameStoreBase.tipo', context: context);

  @override
  String get tipo {
    _$tipoAtom.reportRead();
    return super.tipo;
  }

  @override
  set tipo(String value) {
    _$tipoAtom.reportWrite(value, super.tipo, () {
      super.tipo = value;
    });
  }

  late final _$imagemAtom =
      Atom(name: '_ExameStoreBase.imagem', context: context);

  @override
  String? get imagem {
    _$imagemAtom.reportRead();
    return super.imagem;
  }

  @override
  set imagem(String? value) {
    _$imagemAtom.reportWrite(value, super.imagem, () {
      super.imagem = value;
    });
  }

  late final _$createdAtAtom =
      Atom(name: '_ExameStoreBase.createdAt', context: context);

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
dataRealizacao: ${dataRealizacao},
tipo: ${tipo},
imagem: ${imagem},
createdAt: ${createdAt}
    ''';
  }
}

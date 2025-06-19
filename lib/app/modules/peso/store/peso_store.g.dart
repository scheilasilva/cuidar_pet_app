// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peso_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PesoStore on _PesoStoreBase, Store {
  late final _$idAtom = Atom(name: '_PesoStoreBase.id', context: context);

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
      Atom(name: '_PesoStoreBase.animalId', context: context);

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

  late final _$pesoAtom = Atom(name: '_PesoStoreBase.peso', context: context);

  @override
  double get peso {
    _$pesoAtom.reportRead();
    return super.peso;
  }

  @override
  set peso(double value) {
    _$pesoAtom.reportWrite(value, super.peso, () {
      super.peso = value;
    });
  }

  late final _$dataPesagemAtom =
      Atom(name: '_PesoStoreBase.dataPesagem', context: context);

  @override
  DateTime get dataPesagem {
    _$dataPesagemAtom.reportRead();
    return super.dataPesagem;
  }

  @override
  set dataPesagem(DateTime value) {
    _$dataPesagemAtom.reportWrite(value, super.dataPesagem, () {
      super.dataPesagem = value;
    });
  }

  late final _$observacaoAtom =
      Atom(name: '_PesoStoreBase.observacao', context: context);

  @override
  String? get observacao {
    _$observacaoAtom.reportRead();
    return super.observacao;
  }

  @override
  set observacao(String? value) {
    _$observacaoAtom.reportWrite(value, super.observacao, () {
      super.observacao = value;
    });
  }

  late final _$createdAtAtom =
      Atom(name: '_PesoStoreBase.createdAt', context: context);

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
peso: ${peso},
dataPesagem: ${dataPesagem},
observacao: ${observacao},
createdAt: ${createdAt}
    ''';
  }
}

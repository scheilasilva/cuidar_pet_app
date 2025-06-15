// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnimalStore on _AnimalStoreBase, Store {
  late final _$idAtom = Atom(name: '_AnimalStoreBase.id', context: context);

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

  late final _$nomeAtom = Atom(name: '_AnimalStoreBase.nome', context: context);

  @override
  String get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$imagemAtom =
      Atom(name: '_AnimalStoreBase.imagem', context: context);

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

  late final _$tipoAnimalAtom =
      Atom(name: '_AnimalStoreBase.tipoAnimal', context: context);

  @override
  String get tipoAnimal {
    _$tipoAnimalAtom.reportRead();
    return super.tipoAnimal;
  }

  @override
  set tipoAnimal(String value) {
    _$tipoAnimalAtom.reportWrite(value, super.tipoAnimal, () {
      super.tipoAnimal = value;
    });
  }

  late final _$idadeAtom =
      Atom(name: '_AnimalStoreBase.idade', context: context);

  @override
  int get idade {
    _$idadeAtom.reportRead();
    return super.idade;
  }

  @override
  set idade(int value) {
    _$idadeAtom.reportWrite(value, super.idade, () {
      super.idade = value;
    });
  }

  late final _$generoAtom =
      Atom(name: '_AnimalStoreBase.genero', context: context);

  @override
  String get genero {
    _$generoAtom.reportRead();
    return super.genero;
  }

  @override
  set genero(String value) {
    _$generoAtom.reportWrite(value, super.genero, () {
      super.genero = value;
    });
  }

  late final _$pesoAtom = Atom(name: '_AnimalStoreBase.peso', context: context);

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

  @override
  String toString() {
    return '''
id: ${id},
nome: ${nome},
imagem: ${imagem},
tipoAnimal: ${tipoAnimal},
idade: ${idade},
genero: ${genero},
peso: ${peso}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consulta_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConsultaStore on _ConsultaStoreBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_ConsultaStoreBase.isFormValid'))
          .value;

  late final _$idAtom = Atom(name: '_ConsultaStoreBase.id', context: context);

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
      Atom(name: '_ConsultaStoreBase.animalId', context: context);

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
      Atom(name: '_ConsultaStoreBase.titulo', context: context);

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
      Atom(name: '_ConsultaStoreBase.descricao', context: context);

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

  late final _$dataConsultaAtom =
      Atom(name: '_ConsultaStoreBase.dataConsulta', context: context);

  @override
  String get dataConsulta {
    _$dataConsultaAtom.reportRead();
    return super.dataConsulta;
  }

  @override
  set dataConsulta(String value) {
    _$dataConsultaAtom.reportWrite(value, super.dataConsulta, () {
      super.dataConsulta = value;
    });
  }

  late final _$tipoAtom =
      Atom(name: '_ConsultaStoreBase.tipo', context: context);

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
      Atom(name: '_ConsultaStoreBase.imagem', context: context);

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
      Atom(name: '_ConsultaStoreBase.createdAt', context: context);

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

  late final _$_ConsultaStoreBaseActionController =
      ActionController(name: '_ConsultaStoreBase', context: context);

  @override
  void setTitulo(String value) {
    final _$actionInfo = _$_ConsultaStoreBaseActionController.startAction(
        name: '_ConsultaStoreBase.setTitulo');
    try {
      return super.setTitulo(value);
    } finally {
      _$_ConsultaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescricao(String value) {
    final _$actionInfo = _$_ConsultaStoreBaseActionController.startAction(
        name: '_ConsultaStoreBase.setDescricao');
    try {
      return super.setDescricao(value);
    } finally {
      _$_ConsultaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataConsulta(String value) {
    final _$actionInfo = _$_ConsultaStoreBaseActionController.startAction(
        name: '_ConsultaStoreBase.setDataConsulta');
    try {
      return super.setDataConsulta(value);
    } finally {
      _$_ConsultaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImagem(String? value) {
    final _$actionInfo = _$_ConsultaStoreBaseActionController.startAction(
        name: '_ConsultaStoreBase.setImagem');
    try {
      return super.setImagem(value);
    } finally {
      _$_ConsultaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
animalId: ${animalId},
titulo: ${titulo},
descricao: ${descricao},
dataConsulta: ${dataConsulta},
tipo: ${tipo},
imagem: ${imagem},
createdAt: ${createdAt},
isFormValid: ${isFormValid}
    ''';
  }
}

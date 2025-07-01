import 'package:cuidar_pet_app/app/modules/vacinacao/services/vacinacao_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/vacinacao/store/vacinacao_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'vacinacao_controller.g.dart';

class VacinacaoController = _VacinacaoControllerBase with _$VacinacaoController;

abstract class _VacinacaoControllerBase with Store {
  final IVacinacaoService _service;

  @observable
  VacinacaoStore vacinacao = VacinacaoStoreFactory.novo('');

  @observable
  ObservableList<VacinacaoStore> vacinacoes = ObservableList<VacinacaoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _VacinacaoControllerBase(this._service);

  @computed
  bool get isFormValid {
    final v = vacinacao;
    return v.titulo.isNotEmpty &&
        v.descricao.isNotEmpty &&
        v.dataVacinacao.isNotEmpty &&
        v.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    vacinacao = VacinacaoStoreFactory.novo(animalId);
    loadVacinacoesByAnimal(animalId);
  }

  // Carregar vacinações do animal selecionado
  @action
  Future<void> loadVacinacoesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      vacinacoes.clear();

      for (var vacinacao in list) {
        vacinacoes.add(VacinacaoStoreFactory.fromModel(vacinacao));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar vacinação
  @action
  Future<void> salvarVacinacao() async {
    if (animalSelecionadoId == null) return;

    vacinacao.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(vacinacao.toModel());
    await loadVacinacoesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova vacinação
  @action
  Future<void> criarVacinacao(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novaVacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
    novaVacinacao.titulo = titulo;
    novaVacinacao.descricao = descricao;
    novaVacinacao.dataVacinacao = data;
    novaVacinacao.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novaVacinacao.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novaVacinacao.toModel());
    }

    await loadVacinacoesByAnimal(animalSelecionadoId!);
  }

  // Marcar vacinação como concluída
  @action
  Future<void> marcarComoConcluida(VacinacaoStore vacinacaoStore, bool concluida) async {
    vacinacaoStore.concluida = concluida;
    await _service.saveOrUpdate(vacinacaoStore.toModel());

    if (animalSelecionadoId != null) {
      await loadVacinacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Excluir vacinação específica
  @action
  Future<void> excluirVacinacao(VacinacaoStore vacinacaoParaExcluir) async {
    await _service.delete(vacinacaoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadVacinacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      vacinacao = VacinacaoStoreFactory.novo(animalSelecionadoId!);
    }
  }
}

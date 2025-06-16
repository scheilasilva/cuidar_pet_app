import 'package:cuidar_pet_app/app/modules/exame/services/exame_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/exame/store/exame_store.dart';
import 'package:mobx/mobx.dart';

part 'exame_controller.g.dart';

class ExameController = _ExameControllerBase with _$ExameController;

abstract class _ExameControllerBase with Store {
  final IExameService _service;

  @observable
  ExameStore exame = ExameStoreFactory.novo('');

  @observable
  ObservableList<ExameStore> exames = ObservableList<ExameStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _ExameControllerBase(this._service);

  @computed
  bool get isFormValid {
    final e = exame;
    return e.titulo.isNotEmpty &&
        e.descricao.isNotEmpty &&
        e.dataRealizacao.isNotEmpty &&
        e.tipo.isNotEmpty &&
        e.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    exame = ExameStoreFactory.novo(animalId);
    loadExamesByAnimal(animalId);
  }

  // Carregar exames do animal selecionado
  @action
  Future<void> loadExamesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      exames.clear();

      for (var exame in list) {
        exames.add(ExameStoreFactory.fromModel(exame));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar exame
  @action
  Future<void> salvarExame() async {
    if (animalSelecionadoId == null) return;

    exame.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(exame.toModel());
    await loadExamesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // NOVO: Criar novo exame com imagem
  @action
  Future<void> criarExameComImagem(String titulo, String descricao, String data, String tipo, String imagePath) async {
    if (animalSelecionadoId == null) return;

    final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
    novoExame.titulo = titulo;
    novoExame.descricao = descricao;
    novoExame.dataRealizacao = data;
    novoExame.tipo = tipo;

    await _service.saveOrUpdateWithImage(novoExame.toModel(), imagePath);
    await loadExamesByAnimal(animalSelecionadoId!);
  }

  // Criar novo exame sem imagem (mantém compatibilidade)
  @action
  Future<void> criarExame(String titulo, String descricao, String data, String tipo, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novoExame = ExameStoreFactory.novo(animalSelecionadoId!);
    novoExame.titulo = titulo;
    novoExame.descricao = descricao;
    novoExame.dataRealizacao = data;
    novoExame.tipo = tipo;
    novoExame.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novoExame.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novoExame.toModel());
    }

    await loadExamesByAnimal(animalSelecionadoId!);
  }

  // Excluir exame específico
  @action
  Future<void> excluirExame(ExameStore exameParaExcluir) async {
    await _service.delete(exameParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadExamesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      exame = ExameStoreFactory.novo(animalSelecionadoId!);
    }
  }
}
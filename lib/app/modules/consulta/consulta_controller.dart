import 'package:cuidar_pet_app/app/modules/consulta/services/consulta_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/consulta/store/consulta_store.dart';
import 'package:mobx/mobx.dart';

part 'consulta_controller.g.dart';

class ConsultaController = _ConsultaControllerBase with _$ConsultaController;

abstract class _ConsultaControllerBase with Store {
  final IConsultaService _service;

  @observable
  ConsultaStore consulta = ConsultaStoreFactory.novo('');

  @observable
  ObservableList<ConsultaStore> consultas = ObservableList<ConsultaStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _ConsultaControllerBase(this._service);

  @computed
  bool get isFormValid {
    final c = consulta;
    return c.titulo.isNotEmpty &&
        c.descricao.isNotEmpty &&
        c.dataConsulta.isNotEmpty &&
        c.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    consulta = ConsultaStoreFactory.novo(animalId);
    loadConsultasByAnimal(animalId);
  }

  // Carregar consultas do animal selecionado
  @action
  Future<void> loadConsultasByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      consultas.clear();

      for (var consulta in list) {
        consultas.add(ConsultaStoreFactory.fromModel(consulta));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar consulta
  @action
  Future<void> salvarConsulta() async {
    if (animalSelecionadoId == null) return;

    consulta.animalId = animalSelecionadoId!;
    await _service.saveOrUpdate(consulta.toModel());
    await loadConsultasByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova consulta
  @action
  Future<void> criarConsulta(String titulo, String descricao, String data, String? imagem) async {
    if (animalSelecionadoId == null) return;

    final novaConsulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
    novaConsulta.titulo = titulo;
    novaConsulta.descricao = descricao;
    novaConsulta.dataConsulta = data;
    novaConsulta.imagem = imagem;

    if (imagem != null && imagem.isNotEmpty) {
      await _service.saveOrUpdateWithImage(novaConsulta.toModel(), imagem);
    } else {
      await _service.saveOrUpdate(novaConsulta.toModel());
    }

    await loadConsultasByAnimal(animalSelecionadoId!);
  }

  // Excluir consulta específica
  @action
  Future<void> excluirConsulta(ConsultaStore consultaParaExcluir) async {
    await _service.delete(consultaParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadConsultasByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      consulta = ConsultaStoreFactory.novo(animalSelecionadoId!);
    }
  }
}

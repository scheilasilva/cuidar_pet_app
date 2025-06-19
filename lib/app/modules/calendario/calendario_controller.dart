import 'package:cuidar_pet_app/app/modules/calendario/lembrete/services/lembrete_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/calendario/lembrete/store/lembrete_store.dart';
import 'package:mobx/mobx.dart';

part 'calendario_controller.g.dart';

class CalendarioController = _CalendarioControllerBase with _$CalendarioController;

abstract class _CalendarioControllerBase with Store {
  final ILembreteService _service;

  @observable
  LembreteStore lembrete = LembreteStoreFactory.novo('', DateTime.now());

  @observable
  ObservableList<LembreteStore> lembretes = ObservableList<LembreteStore>();

  @observable
  ObservableList<LembreteStore> lembretesDataSelecionada = ObservableList<LembreteStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  DateTime dataSelecionada = DateTime.now();

  @observable
  bool isLoading = false;

  _CalendarioControllerBase(this._service);

  @computed
  bool get isFormValid {
    final l = lembrete;
    return l.titulo.isNotEmpty &&
        l.descricao.isNotEmpty &&
        l.categoria.isNotEmpty &&
        l.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    lembrete = LembreteStoreFactory.novo(animalId, dataSelecionada);
    loadLembretesByAnimal(animalId);
    loadLembretesByDate(dataSelecionada, animalId);
  }

  // Definir data selecionada
  @action
  void setDataSelecionada(DateTime data) {
    dataSelecionada = data;
    if (animalSelecionadoId != null) {
      loadLembretesByDate(data, animalSelecionadoId!);
    }
  }

  // Carregar lembretes do animal selecionado
  @action
  Future<void> loadLembretesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      lembretes.clear();

      for (var lembrete in list) {
        lembretes.add(LembreteStoreFactory.fromModel(lembrete));
      }
    } finally {
      isLoading = false;
    }
  }

  // Carregar lembretes da data selecionada
  @action
  Future<void> loadLembretesByDate(DateTime data, String animalId) async {
    try {
      final list = await _service.getByDate(data, animalId);
      lembretesDataSelecionada.clear();

      for (var lembrete in list) {
        lembretesDataSelecionada.add(LembreteStoreFactory.fromModel(lembrete));
      }
    } catch (e) {
      // Tratar erro se necessário
    }
  }

  // Criar novo lembrete
  @action
  Future<void> criarLembrete(String titulo, String descricao, DateTime data, String categoria, bool concluido) async {
    if (animalSelecionadoId == null) return;

    final novoLembrete = LembreteStoreFactory.novo(animalSelecionadoId!, data);
    novoLembrete.titulo = titulo;
    novoLembrete.descricao = descricao;
    novoLembrete.dataLembrete = data;
    novoLembrete.categoria = categoria;
    novoLembrete.concluido = concluido;

    await _service.saveOrUpdate(novoLembrete.toModel());
    await loadLembretesByAnimal(animalSelecionadoId!);
    await loadLembretesByDate(dataSelecionada, animalSelecionadoId!);
  }

  // Marcar lembrete como concluído
  @action
  Future<void> marcarComoConcluido(LembreteStore lembreteStore, bool concluido) async {
    lembreteStore.concluido = concluido;
    await _service.saveOrUpdate(lembreteStore.toModel());

    if (animalSelecionadoId != null) {
      await loadLembretesByAnimal(animalSelecionadoId!);
      await loadLembretesByDate(dataSelecionada, animalSelecionadoId!);
    }
  }

  // Excluir lembrete específico
  @action
  Future<void> excluirLembrete(LembreteStore lembreteParaExcluir) async {
    await _service.delete(lembreteParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadLembretesByAnimal(animalSelecionadoId!);
      await loadLembretesByDate(dataSelecionada, animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      lembrete = LembreteStoreFactory.novo(animalSelecionadoId!, dataSelecionada);
    }
  }

  // Verificar se uma data tem lembretes
  bool hasLembretesForDate(DateTime date) {
    return lembretes.any((lembrete) =>
    lembrete.dataLembrete.year == date.year &&
        lembrete.dataLembrete.month == date.month &&
        lembrete.dataLembrete.day == date.day
    );
  }
}

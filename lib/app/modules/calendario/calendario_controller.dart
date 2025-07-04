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

  // Adicionar uma propriedade observável para forçar rebuild do calendário
  @observable
  int _calendarRebuildTrigger = 0;

  // Adicionar getter para acessar o trigger
  int get calendarRebuildTrigger => _calendarRebuildTrigger;

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
    // Normalizar a data selecionada
    dataSelecionada = DateTime(data.year, data.month, data.day);
    if (animalSelecionadoId != null) {
      loadLembretesByDate(dataSelecionada, animalSelecionadoId!);
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

      // Forçar rebuild do calendário após carregar lembretes
      _calendarRebuildTrigger++;
    } finally {
      isLoading = false;
    }
  }

  // Carregar lembretes da data selecionada
  @action
  Future<void> loadLembretesByDate(DateTime data, String animalId) async {
    try {
      // Normalizar a data antes de buscar
      final dataNormalizada = DateTime(data.year, data.month, data.day);
      final list = await _service.getByDate(dataNormalizada, animalId);
      lembretesDataSelecionada.clear();

      for (var lembrete in list) {
        lembretesDataSelecionada.add(LembreteStoreFactory.fromModel(lembrete));
      }
    } catch (e) {
      // Tratar erro se necessário
      print('Erro ao carregar lembretes por data: $e');
    }
  }

  // Criar novo lembrete
  @action
  Future<void> criarLembrete(String titulo, String descricao, DateTime data, String categoria, bool concluido) async {
    if (animalSelecionadoId == null) return;

    // Normalizar a data do lembrete
    final dataNormalizada = DateTime(data.year, data.month, data.day, 12, 0, 0);

    final novoLembrete = LembreteStoreFactory.novo(animalSelecionadoId!, dataNormalizada);
    novoLembrete.titulo = titulo;
    novoLembrete.descricao = descricao;
    novoLembrete.dataLembrete = dataNormalizada;
    novoLembrete.categoria = categoria;
    novoLembrete.concluido = concluido;

    await _service.saveOrUpdate(novoLembrete.toModel());
    await loadLembretesByAnimal(animalSelecionadoId!);
    await loadLembretesByDate(dataSelecionada, animalSelecionadoId!);

    // Forçar rebuild do calendário
    _calendarRebuildTrigger++;
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

    // Forçar rebuild do calendário
    _calendarRebuildTrigger++;
  }

  // Excluir lembrete específico
  @action
  Future<void> excluirLembrete(LembreteStore lembreteParaExcluir) async {
    await _service.delete(lembreteParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadLembretesByAnimal(animalSelecionadoId!);
      await loadLembretesByDate(dataSelecionada, animalSelecionadoId!);
    }

    // Forçar rebuild do calendário
    _calendarRebuildTrigger++;
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
    // Normalizar a data para comparação
    final dataNormalizada = DateTime(date.year, date.month, date.day);

    return lembretes.any((lembrete) {
      final lembreteData = DateTime(
        lembrete.dataLembrete.year,
        lembrete.dataLembrete.month,
        lembrete.dataLembrete.day,
      );
      return lembreteData.isAtSameMomentAs(dataNormalizada);
    });
  }
}

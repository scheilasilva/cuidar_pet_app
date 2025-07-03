import 'package:cuidar_pet_app/app/modules/alimentacao/services/alimentacao_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/alimentacao/store/alimentacao_store.dart';
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_service.dart' show NotificacoesService;
import 'package:cuidar_pet_app/app/modules/notificacoes/services/notificacoes_settings_service.dart' show NotificacoesSettingsService;
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'alimentacao_controller.g.dart';

class AlimentacaoController = _AlimentacaoControllerBase with _$AlimentacaoController;

abstract class _AlimentacaoControllerBase with Store {
  final IAlimentacaoService _service;
  final NotificacoesService _notificacoesService = NotificacoesService();
  final NotificacoesSettingsService _settingsService = NotificacoesSettingsService();

  @observable
  AlimentacaoStore alimentacao = AlimentacaoStoreFactory.novo('');

  @observable
  ObservableList<AlimentacaoStore> alimentacoes = ObservableList<AlimentacaoStore>();

  @observable
  String? animalSelecionadoId;

  @observable
  bool isLoading = false;

  _AlimentacaoControllerBase(this._service);

  @computed
  bool get isFormValid {
    final a = alimentacao;
    return a.titulo.isNotEmpty &&
        a.horario.isNotEmpty &&
        a.alimento.isNotEmpty &&
        a.observacao.isNotEmpty &&
        a.animalId.isNotEmpty;
  }

  // Definir animal selecionado
  @action
  void setAnimalSelecionado(String animalId) {
    animalSelecionadoId = animalId;
    alimentacao = AlimentacaoStoreFactory.novo(animalId);
    loadAlimentacoesByAnimal(animalId);
  }

  // Carregar alimentações do animal selecionado
  @action
  Future<void> loadAlimentacoesByAnimal(String animalId) async {
    try {
      isLoading = true;
      final list = await _service.getByAnimalId(animalId);
      alimentacoes.clear();

      for (var alimentacao in list) {
        alimentacoes.add(AlimentacaoStoreFactory.fromModel(alimentacao));
      }
    } finally {
      isLoading = false;
    }
  }

  // Salvar alimentação
  @action
  Future<void> salvarAlimentacao() async {
    if (animalSelecionadoId == null) return;

    alimentacao.animalId = animalSelecionadoId!;

    // Gerar ID se não existir
    if (alimentacao.id.isEmpty) {
      alimentacao.id = const Uuid().v4();
    }

    await _service.saveOrUpdate(alimentacao.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(alimentacao);

    await loadAlimentacoesByAnimal(animalSelecionadoId!);
    resetForm();
  }

  // Criar nova alimentação
  @action
  Future<void> criarAlimentacao(String titulo, String horario, String alimento, String observacao) async {
    if (animalSelecionadoId == null) return;

    final novaAlimentacao = AlimentacaoStoreFactory.novo(animalSelecionadoId!);

    // Gerar ID antes de salvar
    novaAlimentacao.id = const Uuid().v4();
    novaAlimentacao.titulo = titulo;
    novaAlimentacao.horario = horario;
    novaAlimentacao.alimento = alimento;
    novaAlimentacao.observacao = observacao;

    print('🍽️ Criando alimentação com ID: ${novaAlimentacao.id}');

    await _service.saveOrUpdate(novaAlimentacao.toModel());

    // Agendar notificação se estiver habilitada
    await _scheduleNotificacaoIfEnabled(novaAlimentacao);

    await loadAlimentacoesByAnimal(animalSelecionadoId!);
  }

  // Excluir alimentação específica
  @action
  Future<void> excluirAlimentacao(AlimentacaoStore alimentacaoParaExcluir) async {
    // Cancelar notificação agendada
    await _notificacoesService.cancelAlimentacaoNotification(alimentacaoParaExcluir.id);

    await _service.delete(alimentacaoParaExcluir.toModel());
    if (animalSelecionadoId != null) {
      await loadAlimentacoesByAnimal(animalSelecionadoId!);
    }
  }

  // Resetar formulário
  @action
  void resetForm() {
    if (animalSelecionadoId != null) {
      alimentacao = AlimentacaoStoreFactory.novo(animalSelecionadoId!);
    }
  }

  // Método privado para agendar notificação se habilitada
  Future<void> _scheduleNotificacaoIfEnabled(AlimentacaoStore alimentacao) async {
    final isEnabled = await _settingsService.isAlimentacaoEnabled();
    if (!isEnabled) {
      print('🔕 Notificações de alimentação desabilitadas');
      return;
    }

    // Aqui você precisaria obter o nome do animal
    // Assumindo que você tem acesso ao AnimalController ou pode buscar o nome
    final animalNome = await _getAnimalNome(alimentacao.animalId);

    print('🔔 Agendando notificação para alimentação ID: ${alimentacao.id}');

    await _notificacoesService.scheduleAlimentacaoNotification(
      alimentacaoId: alimentacao.id,
      titulo: alimentacao.titulo,
      alimento: alimentacao.alimento,
      horario: alimentacao.horario,
      animalNome: animalNome,
      animalId: alimentacao.animalId,
    );
  }

  // Método para obter o nome do animal (você precisa implementar isso)
  Future<String> _getAnimalNome(String animalId) async {
    // Implementar busca do nome do animal pelo ID
    // Por exemplo, usando o AnimalController ou um service
    return 'Pet'; // Placeholder
  }
}

import 'package:cuidar_pet_app/app/modules/animal/services/animal_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/animal/store/animal_store.dart';
import 'package:cuidar_pet_app/app/modules/peso/services/peso_service_interface.dart';
import 'package:cuidar_pet_app/app/modules/peso/store/peso_store.dart';
import 'package:mobx/mobx.dart';

part 'animal_controller.g.dart';

class AnimalController = _AnimalControllerBase with _$AnimalController;

abstract class _AnimalControllerBase with Store {
  final IAnimalService _service;
  final IPesoService _pesoService; // NOVO: Serviço de peso

  @observable
  AnimalStore animal = AnimalStoreFactory.novo();

  @observable
  ObservableList<AnimalStore> animais = ObservableList<AnimalStore>();

  // NOVO: Animal selecionado no carrossel
  @observable
  AnimalStore? animalSelecionadoCarrossel;

  // NOVO: Índice do carrossel selecionado
  @observable
  int carrosselIndex = 0;

  _AnimalControllerBase(this._service, this._pesoService); // MODIFICADO: Adicionado pesoService

  @computed
  bool get isFormValid {
    final a = animal;
    return a.nome.isNotEmpty &&
        a.tipoAnimal.isNotEmpty &&
        a.idade > 0 &&
        a.peso > 0 &&
        a.genero.isNotEmpty;
  }

  // NOVO: Método para definir animal selecionado no carrossel
  @action
  void setAnimalSelecionadoCarrossel(int index) {
    if (index >= 0 && index < animais.length) {
      carrosselIndex = index;
      animalSelecionadoCarrossel = animais[index];
    }
  }

  // Carregar todos os animais
  @action
  Future<void> loadAnimais() async {
    final list = await _service.getAll();
    animais.clear();

    for (var animal in list) {
      animais.add(AnimalStoreFactory.fromModel(animal));
    }

    // Ajustar seleção após carregar
    if (animais.isNotEmpty) {
      // Se o índice atual é válido, manter
      if (carrosselIndex < animais.length) {
        animalSelecionadoCarrossel = animais[carrosselIndex];
      } else {
        // Senão, selecionar o primeiro
        carrosselIndex = 0;
        animalSelecionadoCarrossel = animais.first;
      }
    } else {
      animalSelecionadoCarrossel = null;
      carrosselIndex = 0;
    }
  }

  // Alternativa mais robusta para o método salvarAnimal():

  @action
  Future<void> salvarAnimal() async {
    // Verificar se é um novo animal (sem ID)
    final isNovoAnimal = animal.id.isEmpty;
    final pesoInicial = animal.peso;
    final nomeAnimal = animal.nome; // Para identificar o animal depois

    // Salvar o animal
    await _service.saveOrUpdate(animal.toModel());

    // Se é um novo animal e tem peso > 0, criar registro de peso inicial
    if (isNovoAnimal && pesoInicial > 0) {
      try {
        // Recarregar animais para obter o ID do animal recém-criado
        await loadAnimais();

        // Encontrar o animal pelo nome (mais seguro)
        final animalRecemCriado = animais.firstWhere(
              (a) => a.nome == nomeAnimal,
          orElse: () => animais.isNotEmpty ? animais.last : throw Exception('Animal não encontrado'),
        );

        final pesoStore = PesoStoreFactory.novo(animalRecemCriado.id);
        pesoStore.peso = pesoInicial;
        pesoStore.dataPesagem = DateTime.now();
        pesoStore.observacao = 'Peso inicial do cadastro';

        await _pesoService.saveOrUpdate(pesoStore.toModel());
      } catch (e) {
        // Log do erro, mas não impedir o cadastro do animal
        print('Erro ao criar registro de peso inicial: $e');
      }
    } else {
      await loadAnimais();
    }

    resetForm();
  }

  // Atualizar animal específico (usado no bottom sheet de edição)
  @action
  Future<void> atualizarAnimal(AnimalStore animalParaAtualizar) async {
    await _service.saveOrUpdate(animalParaAtualizar.toModel());
    await loadAnimais();
  }

  // Excluir animal específico
  @action
  Future<void> excluirAnimal(AnimalStore animalParaExcluir) async {
    await _service.delete(animalParaExcluir.toModel());

    // Se o animal excluído era o selecionado, ajustar seleção
    if (animalSelecionadoCarrossel?.id == animalParaExcluir.id) {
      carrosselIndex = 0;
    }

    await loadAnimais();
  }

  // Resetar formulário
  @action
  void resetForm() {
    animal = AnimalStoreFactory.novo();
  }
}
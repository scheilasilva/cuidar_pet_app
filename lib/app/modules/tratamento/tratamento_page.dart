import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/tratamento/tratamento_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_cadastros/bottom_sheet_cadastros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/tratamento_card.dart';
import 'widgets/tratamento_detalhes_bottom_sheet.dart';

class TratamentoPage extends StatefulWidget {
  const TratamentoPage({super.key});

  @override
  State<TratamentoPage> createState() => _TratamentoPageState();
}

class _TratamentoPageState extends State<TratamentoPage> {
  final TratamentoController controller = Modular.get<TratamentoController>();
  final AnimalController animalController = Modular.get<AnimalController>();

  // Estado para controlar qual filtro está selecionado
  bool _emAndamentoSelecionado = true;

  @override
  void initState() {
    super.initState();
    _initializeWithSelectedAnimal();
  }

  void _initializeWithSelectedAnimal() {
    // Usar o animal selecionado do carrossel
    if (animalController.animalSelecionadoCarrossel != null) {
      controller.setAnimalSelecionado(animalController.animalSelecionadoCarrossel!.id,
          animalController.animalSelecionadoCarrossel!.nome);
    } else if (animalController.animais.isNotEmpty) {
      // Fallback: definir o primeiro animal como selecionado
      animalController.setAnimalSelecionadoCarrossel(0);
      controller.setAnimalSelecionado(animalController.animais.first.id,
          animalController.animais.first.nome);
    }
  }

  void _showTratamentoDetalhes(dynamic tratamento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TratamentoDetalhesBottomSheet(
        tratamento: tratamento,
        onDelete: () async {
          await controller.excluirTratamento(tratamento);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tratamento excluído com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        onToggleConcluido: (concluido) async {
          await controller.toggleTratamentoConcluido(tratamento);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(concluido
                    ? 'Tratamento marcado como concluído!'
                    : 'Tratamento marcado como em andamento!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCadastroTratamento() {
    if (controller.animalSelecionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum animal selecionado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheetCadastro(
            titulo: 'Novo tratamento',
            labelCampo1: 'Título do tratamento',
            labelCampo2: 'Descrição do tratamento',
            labelCampo3: 'Data de início do tratamento',
            onSalvar: (titulo, descricao, data, imagem) async {
              await controller.criarTratamento(titulo, descricao, data, imagem);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tratamento cadastrado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        elevation: 0,
        title: const Text(
          'Tratamentos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00845A),
              size: 24,
            ),
            onPressed: () {
              Modular.to.navigate('/$homeRoute');
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header com botão adicionar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Adicionar novo tratamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Clique aqui para adicionar manualmente',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 32,
                            color: Color(0xFF00845A),
                          ),
                          onPressed: _showCadastroTratamento,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botões de filtro
                  Row(
                    children: [
                      // Botão Em andamento
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _emAndamentoSelecionado = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _emAndamentoSelecionado
                                ? const Color(0xFF005A3E)
                                : const Color(0xFF00936B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Em andamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Botão Concluídos
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _emAndamentoSelecionado = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: !_emAndamentoSelecionado
                                ? const Color(0xFF005A3E)
                                : const Color(0xFF00936B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Concluídos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Lista de tratamentos - Cards diretamente no fundo verde
            Expanded(
              child: Observer(
                builder: (_) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  final tratamentos = _emAndamentoSelecionado
                      ? controller.tratamentosEmAndamento
                      : controller.tratamentosConcluidos;

                  if (tratamentos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _emAndamentoSelecionado
                                ? 'Nenhum tratamento em andamento'
                                : 'Nenhum tratamento concluído',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _emAndamentoSelecionado
                                ? 'Adicione o primeiro tratamento do seu pet'
                                : 'Marque tratamentos como concluídos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: tratamentos.length,
                    itemBuilder: (context, index) {
                      final tratamento = tratamentos[index];
                      return TratamentoCard(
                        tratamento: tratamento,
                        onTap: () => _showTratamentoDetalhes(tratamento),
                        onCheckboxChanged: (value) async {
                          await controller.toggleTratamentoConcluido(tratamento);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
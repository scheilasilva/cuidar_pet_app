import 'package:cuidar_pet_app/app/modules/alimentacao/alimentacao_controller.dart';
import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/alimentacao_card.dart';
import 'widgets/alimentacao_detalhes_bottom_sheet.dart';
import 'widgets/bottom_sheet_alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({super.key});

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  final AlimentacaoController controller = Modular.get<AlimentacaoController>();
  final AnimalController animalController = Modular.get<AnimalController>();

  @override
  void initState() {
    super.initState();
    _initializeWithSelectedAnimal();
  }

  void _initializeWithSelectedAnimal() {
    // Usar o animal selecionado do carrossel
    if (animalController.animalSelecionadoCarrossel != null) {
      controller.setAnimalSelecionado(animalController.animalSelecionadoCarrossel!.id);
    } else if (animalController.animais.isNotEmpty) {
      // Fallback: definir o primeiro animal como selecionado
      animalController.setAnimalSelecionadoCarrossel(0);
      controller.setAnimalSelecionado(animalController.animais.first.id);
    }
  }

  void _showAlimentacaoDetalhes(dynamic alimentacao) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlimentacaoDetalhesBottomSheet(
        alimentacao: alimentacao,
        onDelete: () async {
          await controller.excluirAlimentacao(alimentacao);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Alimentação excluída com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCadastroAlimentacao() {
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
          child: BottomSheetAlimentacao(
            onSalvar: (titulo, horario, alimento, observacao) async {
              await controller.criarAlimentacao(titulo, horario, alimento, observacao);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alimentação cadastrada com sucesso!'),
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
          'Alimentação',
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
                            'Adicionar nova alimentação',
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
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline_sharp,
                          size: 80,
                          color: Colors.white,
                        ),
                        onPressed: _showCadastroAlimentacao,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Lista de alimentações - Cards diretamente no fundo verde
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

                  if (controller.alimentacoes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma alimentação cadastrada',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione a primeira alimentação do seu pet',
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
                    itemCount: controller.alimentacoes.length,
                    itemBuilder: (context, index) {
                      final alimentacao = controller.alimentacoes[index];
                      return AlimentacaoCard(
                        alimentacao: alimentacao,
                        onTap: () => _showAlimentacaoDetalhes(alimentacao),
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

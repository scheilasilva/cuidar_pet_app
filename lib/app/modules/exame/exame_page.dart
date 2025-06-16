import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/exame/exame_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_cadastros/bottom_sheet_cadastros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/exame_card.dart';
import 'widgets/exame_detalhes_bottom_sheet.dart';

class ExamePage extends StatefulWidget {
  const ExamePage({super.key});

  @override
  State<ExamePage> createState() => _ExamePageState();
}

class _ExamePageState extends State<ExamePage> {
  final ExameController controller = Modular.get<ExameController>();
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
  void _showExameDetalhes(dynamic exame) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExameDetalhesBottomSheet(
        exame: exame,
        onDelete: () async {
          await controller.excluirExame(exame);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Exame excluído com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCadastroExame() {
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
            titulo: 'Novo exame',
            labelCampo1: 'Título do exame',
            labelCampo2: 'Descrição do exame',
            labelCampo3: 'Data realizada do exame',
            onSalvar: (titulo, descricao, data, tipo, imagem) async {
              await controller.criarExame(titulo, descricao, data, tipo, imagem);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exame cadastrado com sucesso!'),
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
          'Exames',
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
                            'Adicionar novo exame',
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
                          onPressed: _showCadastroExame,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Lista de exames - Cards diretamente no fundo verde
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

                  if (controller.exames.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum exame cadastrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione o primeiro exame do seu pet',
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
                    itemCount: controller.exames.length,
                    itemBuilder: (context, index) {
                      final exame = controller.exames[index];
                      return ExameCard(
                        exame: exame,
                        onTap: () => _showExameDetalhes(exame),
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

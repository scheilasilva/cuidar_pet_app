import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/peso/peso_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/bottom_sheet_novo_peso.dart';

class PesoPage extends StatefulWidget {
  const PesoPage({super.key});

  @override
  State<PesoPage> createState() => _PesoPageState();
}

class _PesoPageState extends State<PesoPage> {
  final PesoController controller = Modular.get<PesoController>();
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

  void _showNovoPeso() {
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
          child: BottomSheetNovoPeso(
            pesoInicial: controller.pesoSelecionado,
            onSalvar: (peso, data, observacao) async {
              await controller.criarPeso(peso, data, observacao);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Peso registrado com sucesso!'),
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
          'Peso',
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
        child: Observer(
          builder: (_) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            // Se não há pesos, mostrar apenas a mensagem no centro
            if (controller.pesos.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Header com botão adicionar - MESMO ESTILO DA VACINACAO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Adicionar novo peso',
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
                            onPressed: _showNovoPeso,
                          ),
                        ),
                      ],
                    ),

                    // Mensagem no centro da tela
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monitor_weight_outlined,
                              size: 64,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum peso registrado',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adicione o primeiro registro de peso do seu pet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Se há pesos, mostrar o layout com card
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header com botão adicionar - MESMO ESTILO DA VACINACAO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Adicionar novo peso',
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
                          onPressed: _showNovoPeso,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Card com lista de pesos
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Cabeçalho da tabela
                            Row(
                              children: const [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Datas de pesagem',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Peso',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Lista de registros de peso
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.pesos.length,
                                itemBuilder: (context, index) {
                                  final peso = controller.pesos[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF00845A),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                peso.dataFormatada,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (peso.observacao != null && peso.observacao!.isNotEmpty)
                                                Text(
                                                  peso.observacao!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                peso.pesoFormatado,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              // Mostrar variação se não for o último registro
                                              if (index < controller.pesos.length - 1)
                                                Text(
                                                  controller.getVariacaoPeso(index),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: controller.getVariacaoPeso(index).startsWith('+')
                                                        ? Colors.green
                                                        : controller.getVariacaoPeso(index).startsWith('-')
                                                        ? Colors.red
                                                        : Colors.grey[600],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
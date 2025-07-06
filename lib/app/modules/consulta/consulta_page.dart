import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/consulta/consulta_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_cadastros/bottom_sheet_cadastros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/consulta_card.dart';
import 'widgets/consulta_detalhes_bottom_sheet.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final ConsultaController controller = Modular.get<ConsultaController>();
  final AnimalController animalController = Modular.get<AnimalController>();

  @override
  void initState() {
    super.initState();
    _initializeWithSelectedAnimal();
  }

  void _initializeWithSelectedAnimal() {
    if (animalController.animalSelecionadoCarrossel != null) {
      controller.setAnimalSelecionado(
          animalController.animalSelecionadoCarrossel!.id,
          animalController.animalSelecionadoCarrossel!.nome);
    } else if (animalController.animais.isNotEmpty) {
      animalController.setAnimalSelecionadoCarrossel(0);
      controller.setAnimalSelecionado(animalController.animais.first.id,
          animalController.animais.first.nome);
    }
  }

  void _showConsultaDetalhes(dynamic consulta) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConsultaDetalhesBottomSheet(
        consulta: consulta,
        onDelete: () async {
          await controller.excluirConsulta(consulta);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Consulta excluída com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCadastroConsulta() {
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
            titulo: 'Nova consulta',
            labelCampo1: 'Título da consulta',
            labelCampo2: 'Descrição da consulta',
            labelCampo3: 'Data da consulta',
            onSalvar: (titulo, descricao, data, imagem) async {
              try {
                // ✅ Usar o método criarConsulta que aceita imagem null
                await controller.criarConsulta(titulo, descricao, data, imagem);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consulta cadastrada com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao cadastrar consulta: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
          'Consultas',
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
                            'Adicionar nova consulta',
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
                          onPressed: _showCadastroConsulta,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Lista de consultas
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

                  if (controller.consultas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma consulta cadastrada',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione a primeira consulta do seu pet',
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
                    itemCount: controller.consultas.length,
                    itemBuilder: (context, index) {
                      final consulta = controller.consultas[index];
                      return ConsultaCard(
                        consulta: consulta,
                        onTap: () => _showConsultaDetalhes(consulta),
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

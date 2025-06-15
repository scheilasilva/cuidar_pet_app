import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_cadastros/bottom_sheet_cadastros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TratamentoPage extends StatefulWidget {
  const TratamentoPage({super.key});

  @override
  State<TratamentoPage> createState() => _TratamentoPageState();
}

class _TratamentoPageState extends State<TratamentoPage> {
  // Estado para controlar qual filtro está selecionado
  bool _emAndamentoSelecionado = true;

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
        child: Stack(
          children: [
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
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline_sharp,
                          size: 80,
                          color: Colors.white,
                        ),
                        onPressed: () {
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
                                  labelCampo3: 'Data realizada do tratamento',
                                  onSalvar: (titulo, descricao, data, tipo, imagem) {
                                    // Implemente aqui a lógica para salvar os dados
                                  },
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16),
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
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _emAndamentoSelecionado
                                ? const Color(
                                    0xFF005A3E) // Verde mais escuro quando selecionado
                                : const Color(0xFF00936B),
                            // Verde mais claro quando não selecionado
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

                  // Aqui você pode adicionar o conteúdo específico para cada estado (Em andamento ou Concluídos)
                  const SizedBox(height: 20),
                  Text(
                    _emAndamentoSelecionado
                        ? 'Tratamentos em andamento'
                        : 'Tratamentos concluídos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

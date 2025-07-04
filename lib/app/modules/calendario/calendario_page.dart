import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/modules/calendario/calendario_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/bottom_sheet_novo_lembrete.dart';
import 'widgets/lembrete_card.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final CalendarioController controller = Modular.get<CalendarioController>();
  final AnimalController animalController = Modular.get<AnimalController>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Aguardar um frame antes de inicializar para garantir que tudo esteja pronto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWithSelectedAnimal();
    });
  }

  void _initializeWithSelectedAnimal() async {
    // Usar o animal selecionado do carrossel
    if (animalController.animalSelecionadoCarrossel != null) {
      controller.setAnimalSelecionado(animalController.animalSelecionadoCarrossel!.id);
    } else if (animalController.animais.isNotEmpty) {
      // Fallback: definir o primeiro animal como selecionado
      animalController.setAnimalSelecionadoCarrossel(0);
      controller.setAnimalSelecionado(animalController.animais.first.id);
    }

    // Garantir que a data atual seja definida
    controller.setDataSelecionada(DateTime.now());
  }

  void _showNovoLembrete() {
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
          child: BottomSheetNovoLembrete(
            dataSelecionada: controller.dataSelecionada,
            onSalvar: (titulo, descricao, data, categoria, concluido) async {
              await controller.criarLembrete(titulo, descricao, data, categoria, concluido);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lembrete criado com sucesso!'),
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
          'Calendário',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Calendário usando table_calendar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Observer(
                  builder: (_) {
                    // Forçar rebuild quando o trigger mudar
                    controller.calendarRebuildTrigger;

                    return TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(controller.dataSelecionada, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                        controller.setDataSelecionada(selectedDay);
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: (day) {
                        // Mostrar indicador se há lembretes neste dia
                        return controller.hasLembretesForDate(day) ? ['lembrete'] : [];
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: false,
                        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black54),
                        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black54),
                        titleTextStyle: TextStyle(fontSize: 16),
                        headerPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF00845A).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFF00845A),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: const TextStyle(color: Colors.red),
                        outsideDaysVisible: true,
                        outsideTextStyle: const TextStyle(color: Colors.grey),
                        markerDecoration: const BoxDecoration(
                          color: Color(0xFF00845A),
                          shape: BoxShape.circle,
                        ),
                        markerSize: 6.0,
                        markersMaxCount: 3,
                        canMarkersOverflow: true,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Botão para adicionar lembrete
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showNovoLembrete,
                  icon: const Icon(Icons.add_circle_outline_sharp),
                  label: const Text(
                    'Adicionar novo lembrete',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Lista de lembretes da data selecionada
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

                    if (controller.lembretesDataSelecionada.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note_outlined,
                              size: 64,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum lembrete para esta data',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adicione um lembrete para organizar sua agenda',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.lembretesDataSelecionada.length,
                      itemBuilder: (context, index) {
                        final lembrete = controller.lembretesDataSelecionada[index];
                        return LembreteCard(
                          lembrete: lembrete,
                          onToggleConcluido: (concluido) async {
                            await controller.marcarComoConcluido(lembrete, concluido);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(concluido
                                      ? 'Lembrete marcado como concluído!'
                                      : 'Lembrete desmarcado como concluído!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
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
      ),
    );
  }
}

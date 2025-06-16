import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuidar_pet_app/app/modules/animal/animal_controller.dart';
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:cuidar_pet_app/app/shared/widget/bottom_sheet_editar_pet/bottom_sheet_editar_pet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<AnimalController>();
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await controller.loadAnimais();

    // Restaurar posição do carrossel após carregar os animais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.animais.isNotEmpty && controller.carrosselIndex > 0) {
        _carouselController.animateToPage(
          controller.carrosselIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _navigateToScreen(String screenName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navegando para: $screenName')),
    );
  }

  // Método para lidar com mudanças no carrossel
  void _onCarouselPageChanged(int index) {
    // Só atualizar se não for o botão "Adicionar Pet"
    if (index < controller.animais.length) {
      controller.setAnimalSelecionadoCarrossel(index);
    }
  }

  // Método para construir a imagem do pet corretamente
  Widget _buildPetImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.pets,
          color: Color(0xFF00845A),
          size: 60,
        ),
      );
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.pets,
              color: Color(0xFF00845A),
              size: 60,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00845A),
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.pets,
                color: Color(0xFF00845A),
                size: 60,
              ),
            );
          },
        );
      } else {
        return Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.pets,
            color: Color(0xFF00845A),
            size: 60,
          ),
        );
      }
    }
  }

  void _mostrarEditarPetBottomSheet(dynamic animal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => EditarPetBottomSheet(
        animal: animal,
        controller: controller,
      ),
    ).then((_) {
      controller.loadAnimais();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        centerTitle: true,
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF00845A),
              size: 24,
            ),
            onPressed: () {
              Modular.to.navigate('$ajustesRoute/');
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF00845A),
                size: 24,
              ),
              onPressed: () {
                Modular.to.navigate('$notificacoesRoute/');
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Observer(
              builder: (_) {
                final carouselItems = [
                  ...controller.animais,
                  null, // Representa o botão "Adicionar Pet"
                ];

                return Column(
                  children: [
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 220,
                        enlargeCenterPage: true,
                        initialPage: controller.carrosselIndex,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          _onCarouselPageChanged(index);
                        },
                      ),
                      items: carouselItems.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            if (item == null) {
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Modular.to.pushNamed('$cadastroAnimalRoute/');
                                  if (result == true) {
                                    controller.loadAnimais();
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add,
                                          color: Color(0xFF00845A),
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Adicionar Pet',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF00845A),
                                              width: 3,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: _buildPetImage(item.imagem),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.nome,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF00845A),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item.tipoAnimal,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFF00845A),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${item.idade} ${item.idade == 1 ? 'ano' : 'anos'}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () => _mostrarEditarPetBottomSheet(item),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF00845A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: carouselItems.asMap().entries.map((entry) {
                        return Observer(
                          builder: (_) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.carrosselIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // Menu Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    MenuOption(
                        label: 'Perfil',
                        imagePath: 'assets/icons/user.png',
                        onTap: () => Modular.to.navigate('$perfilRoute/')),
                    MenuOption(
                      label: 'Exames',
                      imagePath: 'assets/icons/heart-rate.png',
                      onTap: () => Modular.to.navigate('$exameRoute/'),
                    ),
                    MenuOption(
                      label: 'Tratamentos',
                      imagePath: 'assets/icons/drugs.png',
                      onTap: () => Modular.to.navigate('$tratamentoRoute/'),
                    ),
                    MenuOption(
                      label: 'Consultas',
                      imagePath: 'assets/icons/stethoscope.png',
                      onTap: () => Modular.to.navigate('$consultaRoute/'),
                    ),
                    MenuOption(
                      label: 'Vacinações',
                      imagePath: 'assets/icons/syringe.png',
                      onTap: () => Modular.to.navigate('$vacinacaoRoute/'),
                    ),
                    MenuOption(
                      label: 'Calendário',
                      imagePath: 'assets/icons/calendar.png',
                      onTap: () => Modular.to.navigate('$calendarioRoute/'),
                    ),
                    MenuOption(
                      label: 'Emergência',
                      imagePath: 'assets/icons/first-aid-kit.png',
                      onTap: () => _navigateToScreen('Emergência'),
                    ),
                    MenuOption(
                      label: 'Peso',
                      imagePath: 'assets/icons/weighing-machine.png',
                      onTap: () => Modular.to.navigate('$pesoRoute/'),
                    ),
                    MenuOption(
                      label: 'Alimentação',
                      imagePath: 'assets/icons/pet-food.png',
                      onTap: () => Modular.to.navigate('$alimentacaoRoute/'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const MenuOption({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 64,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
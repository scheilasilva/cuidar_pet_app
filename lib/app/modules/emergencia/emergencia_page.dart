import 'package:cuidar_pet_app/app/modules/emergencia/emergencia_controller.dart';
import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/widgets/mapa_veterinarios.dart' show MapaVeterinarios;
import 'package:cuidar_pet_app/app/modules/emergencia/submodules/veterinario/widgets/veterinario_card.dart' show VeterinarioCard;
import 'package:cuidar_pet_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';

class EmergenciaPage extends StatefulWidget {
  const EmergenciaPage({super.key});

  @override
  State<EmergenciaPage> createState() => _EmergenciaPageState();
}

class _EmergenciaPageState extends State<EmergenciaPage> {
  final EmergenciaController controller = Modular.get<EmergenciaController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.inicializar();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce para evitar muitas chamadas
    Future.delayed(const Duration(milliseconds: 800), () {
      if (searchController.text == value && mounted) {
        controller.buscarVeterinariosPorTexto(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00845A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00845A),
        elevation: 0,
        title: const Text(
          'Emergência',
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
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color(0xFF00845A),
                size: 24,
              ),
              onPressed: () {
                controller.recarregarDados();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header com informações de emergência
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emergency,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Veterinários próximos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Raio de 30km da sua localização',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Observer(
                  builder: (_) {
                    if (controller.isLoadingLocation) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF00845A),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Obtendo sua localização...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                controller.errorMessage!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => controller.recarregarDados(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00845A),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Barra de pesquisa
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: _onSearchChanged,
                              decoration: InputDecoration(
                                hintText: 'Pesquisar nas proximidades',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[600],
                                ),
                                suffixIcon: Observer(
                                  builder: (_) {
                                    if (controller.isSearching) {
                                      return const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF00845A),
                                          ),
                                        ),
                                      );
                                    }

                                    if (searchController.text.isNotEmpty) {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          controller.limparPesquisa();
                                        },
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Mapa
                          if (controller.localizacaoAtual != null)
                            MapaVeterinarios(
                              localizacaoUsuario: LatLng(
                                controller.localizacaoAtual!.latitude,
                                controller.localizacaoAtual!.longitude,
                              ),
                              veterinarios: controller.veterinarios,
                              onVeterinarioTap: (veterinario) {
                                controller.selecionarVeterinario(veterinario);
                              },
                            ),

                          const SizedBox(height: 20),

                          // Filtros rápidos
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip('Abertos agora', false),
                                const SizedBox(width: 8),
                                _buildFilterChip('Bem avaliados', false),
                                const SizedBox(width: 8),
                                _buildFilterChip('Emergência 24h', false),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Lista de veterinários
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Veterinários encontrados (${controller.veterinarios.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              if (controller.isLoadingAny)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF00845A),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          if (controller.veterinarios.isEmpty && !controller.isLoadingAny)
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum veterinário encontrado',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tente expandir a área de busca ou verificar sua conexão',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ...controller.veterinarios.map((veterinario) {
                              return VeterinarioCard(
                                veterinario: veterinario,
                                onTap: () => controller.selecionarVeterinario(veterinario),
                              );
                            }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        // TODO: Implementar lógica de filtro
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF00845A),
      checkmarkColor: Colors.white,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

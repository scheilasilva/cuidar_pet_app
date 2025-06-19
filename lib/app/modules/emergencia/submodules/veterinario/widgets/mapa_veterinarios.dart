import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/veterinario_model.dart';

class MapaVeterinarios extends StatelessWidget {
  final LatLng? localizacaoUsuario;
  final List<VeterinarioModel> veterinarios;
  final Function(VeterinarioModel)? onVeterinarioTap;

  const MapaVeterinarios({
    super.key,
    this.localizacaoUsuario,
    required this.veterinarios,
    this.onVeterinarioTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: localizacaoUsuario ?? const LatLng(-23.5505, -46.6333), // São Paulo como fallback
            initialZoom: 14.0,
            maxZoom: 18.0,
            minZoom: 10.0,
          ),
          children: [
            // Camada do mapa
            TileLayer(
              urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic2NoZWlsYWFsYmlubyIsImEiOiJjbWMzdXpkaXAwOTZ3Mmtwc3d3Nm8yN2N3In0.jMLKs6A4pJyD13-aPDgq1g',
              additionalOptions: const {
                'accessToken': 'pk.eyJ1Ijoic2NoZWlsYWFsYmlubyIsImEiOiJjbWMzdXpkaXAwOTZ3Mmtwc3d3Nm8yN2N3In0.jMLKs6A4pJyD13-aPDgq1g',
              },
            ),

            // Marcadores
            MarkerLayer(
              markers: [
                // Marcador do usuário
                if (localizacaoUsuario != null)
                  Marker(
                    point: localizacaoUsuario!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                // Marcadores dos veterinários
                ...veterinarios.map((veterinario) {
                  return Marker(
                    point: LatLng(veterinario.latitude, veterinario.longitude),
                    child: GestureDetector(
                      onTap: () => onVeterinarioTap?.call(veterinario),
                      child: Container(
                        decoration: BoxDecoration(
                          color: veterinario.emergencia24h ? Colors.red : const Color(0xFF00845A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

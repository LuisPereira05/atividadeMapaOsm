import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodels/location_viewmodel.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final location = viewModel.location;
        final currentLocation = viewModel.currentLocation;

        if (location == null) {
          return const Center(
            child: Text('Não foi possível obter a localização.'),
          );
        }

        return Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Buscar endereço...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await viewModel.searchAddress(_controller.text);
                      if (viewModel.location != null) {
                        _mapController.move(
                          LatLng(viewModel.location!.latitude,
                              viewModel.location!.longitude),
                          15,
                        );
                      }
                    },
                  ),
                ),
                onSubmitted: (val) async {
                  await viewModel.searchAddress(val);
                  if (viewModel.location != null) {
                    _mapController.move(
                      LatLng(viewModel.location!.latitude,
                          viewModel.location!.longitude),
                      15,
                    );
                  }
                },
              ),
            ),

            // 🗺️ Map
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      LatLng(location.latitude, location.longitude),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'br.edu.ifsul.flutter_mapas_osm',
                  ),
                  MarkerLayer(
                    markers: [
                      // 📍 marcador do endereço buscado
                      Marker(
                        point: LatLng(location.latitude, location.longitude),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),

                      // 📍 marcador da posição atual em tempo real
                      if (currentLocation != null)
                        Marker(
                          point: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../services/geocoding_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();

  LocationModel? _location;          // Localização principal (busca inicial)
  LocationModel? _currentLocation;   // Localização atual em tempo real
  bool _isLoading = true;

  StreamSubscription<Position>? _positionStream;

  LocationModel? get location => _location;
  LocationModel? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    Position? position = await _locationService.getCurrentPosition();

    if (position != null) {
      _location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _currentLocation = _location; // começa igual
    }

    _isLoading = false;
    notifyListeners();

    _startLocationStream();
  }

  void _startLocationStream() {
    _positionStream?.cancel(); // evitar duplicado
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // atualiza a cada 5 metros
      ),
    ).listen((Position position) {
      _currentLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      notifyListeners();
    });
  }

  Future<void> searchAddress(String query) async {
    _isLoading = true;
    notifyListeners();

    final result = await _geocodingService.searchAddress(query);

    if (result != null) {
      _location = LocationModel(
        latitude: result["lat"]!,
        longitude: result["lon"]!,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}

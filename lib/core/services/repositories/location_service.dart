import 'package:geolocator/geolocator.dart';

import '../interfaces/location_interface.dart';

class LocationService implements ILocation {
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition() async {
    final bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado.');
    }

    LocationPermission permission = await checkLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestLocationPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Permissão de localização foi negada.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização foi negada permanentemente. '
        'Acesse as configurações do app para habilitar.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}

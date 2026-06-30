import 'package:geolocator/geolocator.dart';

abstract class ILocation {
  /// Verifica se o serviço de localização está habilitado no dispositivo
  Future<bool> isLocationServiceEnabled();

  /// Solicita permissão de localização ao usuário
  /// Retorna a permissão concedida
  Future<LocationPermission> requestLocationPermission();

  /// Verifica o status atual da permissão
  Future<LocationPermission> checkLocationPermission();

  /// Obtém a localização atual do dispositivo
  /// Lança exceção se não houver permissão ou serviço desabilitado
  Future<Position> getCurrentPosition();
}

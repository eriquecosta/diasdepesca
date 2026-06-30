import 'dart:convert';

import 'package:dias_de_pesca/app/modules/weather/weather_store.dart';
import 'package:dias_de_pesca/core/services/interfaces/location_interface.dart';
import 'package:dias_de_pesca/core/services/interfaces/weather_interface.dart';
import 'package:dias_de_pesca/core/local/models/weather_local_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import '../../../fixtures/weather_fixture.dart';

class _FakeWeatherService implements IWeather {
  _FakeWeatherService({
    this.initialWeather,
    this.refreshedWeather,
    this.fetchResult = true,
    this.throwOnInitialGet = false,
  });

  final WeatherLocalModel? initialWeather;
  final WeatherLocalModel? refreshedWeather;
  final bool fetchResult;
  final bool throwOnInitialGet;

  int getCalls = 0;
  int fetchCalls = 0;

  @override
  Future<bool> fetch(
    double _latitude,
    double _longitude, [
    bool current = true,
    bool hourly = false,
  ]) async {
    fetchCalls++;
    return fetchResult;
  }

  @override
  Future<WeatherLocalModel?> get() async {
    getCalls++;
    if (getCalls == 1 && throwOnInitialGet) {
      throw StateError('sem cache local');
    }

    if (fetchCalls > 0 && refreshedWeather != null) {
      return refreshedWeather!;
    }

    if (initialWeather != null) {
      return initialWeather!;
    }

    throw StateError('sem dados');
  }
}

class _FakeLocationService implements ILocation {
  _FakeLocationService({
    this.latitude = -23.5505,
    this.longitude = -46.6333,
    this.shouldThrow = false,
    this.throwMessage = 'Erro ao obter localização',
  });

  final double latitude;
  final double longitude;
  final bool shouldThrow;
  final String throwMessage;

  @override
  Future<bool> isLocationServiceEnabled() async => !shouldThrow;

  @override
  Future<LocationPermission> checkLocationPermission() async =>
      LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestLocationPermission() async =>
      LocationPermission.whileInUse;

  @override
  Future<Position> getCurrentPosition() async {
    if (shouldThrow) {
      throw Exception(throwMessage);
    }
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }
}

void main() {
  group('WeatherStore', () {
    test('carrega dado local antes de sincronizar', () async {
      final localWeather = WeatherLocalModel(
        id: 1,
        payloadJson: jsonEncode(weatherJsonFixture()),
        cachedAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      final refreshedWeather = WeatherLocalModel(
        id: 1,
        payloadJson: jsonEncode(<String, dynamic>{
          ...weatherJsonFixture(),
          'current': <String, dynamic>{
            ...weatherJsonFixture()['current'] as Map<String, dynamic>,
            'temperature_2m': 24.5,
            'pressure_msl': 905.2,
          },
        }),
        cachedAt: DateTime.now(),
      );
      final service = _FakeWeatherService(
        initialWeather: localWeather,
        refreshedWeather: refreshedWeather,
      );
      final locationService = _FakeLocationService();
      final store = WeatherStore(
        repository: service,
        locationService: locationService,
      );

      await store.loadWeather();

      expect(service.getCalls, 2);
      expect(service.fetchCalls, 1);
      expect(store.currentTemperature, 24.5);
      expect(store.currentPressureMsl, 905.2);
      expect(store.errorMessage, isNull);
      expect(store.isLoading, isFalse);
    });

    test('mantem dado local quando fetch falha', () async {
      final service = _FakeWeatherService(
        initialWeather: WeatherLocalModel(
          id: 1,
          payloadJson: jsonEncode(weatherJsonFixture()),
          cachedAt: DateTime.now(),
        ),
        fetchResult: false,
      );
      final locationService = _FakeLocationService();
      final store = WeatherStore(
        repository: service,
        locationService: locationService,
      );

      await store.loadWeather();

      expect(store.hasWeather, isTrue);
      expect(store.currentTemperature, 21.0);
      expect(store.errorMessage, isNull);
    });

    test('expõe erro quando nao ha cache local e fetch falha', () async {
      final service = _FakeWeatherService(
        fetchResult: false,
        throwOnInitialGet: true,
      );
      final locationService = _FakeLocationService();
      final store = WeatherStore(
        repository: service,
        locationService: locationService,
      );

      await store.loadWeather();

      expect(store.hasWeather, isFalse);
      expect(
        store.errorMessage,
        'Nao foi possivel carregar os dados do clima.',
      );
      expect(store.isLoading, isFalse);
    });

    test('expõe erro quando falha ao obter localização', () async {
      final service = _FakeWeatherService(fetchResult: false);
      final locationService = _FakeLocationService(
        shouldThrow: true,
        throwMessage: 'Permissão de localização foi negada.',
      );
      final store = WeatherStore(
        repository: service,
        locationService: locationService,
      );

      await store.loadWeather();

      expect(store.hasWeather, isFalse);
      expect(store.errorMessage, contains('Permissão de localização'));
      expect(store.isLoading, isFalse);
    });
  });
}

import 'dart:convert';

import 'package:dias_de_pesca/core/local/models/weather_local_model.dart';
import 'package:dias_de_pesca/core/local/repositories/weather_local_repository.dart';
import 'package:dias_de_pesca/core/services/models/weather_model.dart';
import 'package:dias_de_pesca/core/services/repositories/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../fixtures/weather_fixture.dart';

class _FakeWeatherLocalDataSource implements WeatherLocalDataSource {
  _FakeWeatherLocalDataSource({this.latestRecord, this.latestModel});

  WeatherLocalModel? latestRecord;
  WeatherModel? latestModel;
  int saveCalls = 0;

  @override
  Future<WeatherModel?> getLatest() async {
    return latestModel;
  }

  @override
  Future<WeatherLocalModel?> getLatestRecord() async {
    return latestRecord;
  }

  @override
  Future<int> save(WeatherModel weather) async {
    saveCalls++;
    latestModel = weather;
    latestRecord = WeatherLocalModel.fromWeatherModel(
      weather,
      cachedAt: DateTime.now(),
    );
    return 1;
  }
}

void main() {
  group('WeatherRepository', () {
    test('nao chama API quando cache local ja e do dia atual', () async {
      int apiCalls = 0;
      final localDataSource = _FakeWeatherLocalDataSource(
        latestRecord: WeatherLocalModel(
          id: 1,
          cachedAt: DateTime(2026, 6, 15, 8, 30),
          payloadJson: jsonEncode(weatherJsonFixture()),
        ),
      );

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri _) async {
          apiCalls++;
          return http.Response('{}', 500);
        },
        now: () => DateTime(2026, 6, 15, 20, 45),
      );

      final bool result = await repository.fetch();

      expect(result, isTrue);
      expect(apiCalls, 0);
      expect(localDataSource.saveCalls, 0);
    });

    test(
      'chama API e salva localmente quando cache e de dia anterior',
      () async {
        int apiCalls = 0;
        final localDataSource = _FakeWeatherLocalDataSource(
          latestRecord: WeatherLocalModel(
            id: 1,
            cachedAt: DateTime(2026, 6, 14, 23, 59),
            payloadJson: jsonEncode(weatherJsonFixture()),
          ),
        );

        final repository = WeatherRepository(
          localRepository: localDataSource,
          httpGet: (Uri _) async {
            apiCalls++;
            return http.Response(jsonEncode(weatherJsonFixture()), 200);
          },
          now: () => DateTime(2026, 6, 15, 0, 1),
        );

        final bool result = await repository.fetch();

        expect(result, isTrue);
        expect(apiCalls, 1);
        expect(localDataSource.saveCalls, 1);
        expect(localDataSource.latestModel?.timezone, 'GMT');
      },
    );

    test('retorna false quando API falha', () async {
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri _) async => http.Response('error', 500),
        now: () => DateTime(2026, 6, 15),
      );

      final bool result = await repository.fetch();

      expect(result, isFalse);
      expect(localDataSource.saveCalls, 0);
    });

    test('get retorna o ultimo registro local', () async {
      final localDataSource = _FakeWeatherLocalDataSource(
        latestModel: weatherModelFixture(),
      );

      final repository = WeatherRepository(localRepository: localDataSource);

      final WeatherModel weather = await repository.get();

      expect(weather.latitude, -16.06);
      expect(weather.current.temperature2m, 21.0);
    });

    test('get lanca erro quando nao ha registro local', () async {
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(localRepository: localDataSource);

      expect(repository.get, throwsA(isA<StateError>()));
    });
  });
}

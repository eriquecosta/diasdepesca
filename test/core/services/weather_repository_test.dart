import 'dart:convert';

import 'package:dias_de_pesca/core/local/models/weather_local_model.dart';
import 'package:dias_de_pesca/core/local/repositories/weather_local_repository.dart';
import 'package:dias_de_pesca/core/services/models/weather_model.dart';
import 'package:dias_de_pesca/core/services/repositories/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../fixtures/weather_fixture.dart';

class _FakeWeatherLocalDataSource implements WeatherLocalDataSource {
  _FakeWeatherLocalDataSource({this.latestRecord});

  WeatherLocalModel? latestRecord;
  WeatherLocalModel? todayRecord;
  int saveCalls = 0;
  int saveOrUpdateTodayCalls = 0;

  @override
  Future<WeatherLocalModel?> getLatestRecord() async {
    return latestRecord;
  }

  @override
  Future<WeatherLocalModel?> getRecordForToday() async {
    return todayRecord;
  }

  @override
  Future<WeatherModel?> getLatest() async {
    if (latestRecord == null) {
      return null;
    }
    return latestRecord!.toWeatherModel();
  }

  @override
  Future<int> save(WeatherModel weather) async {
    saveCalls++;
    latestRecord = WeatherLocalModel.fromWeatherModel(
      weather,
      cachedAt: DateTime.now(),
    );
    return 1;
  }

  @override
  Future<int> saveOrUpdateToday(WeatherModel weather) async {
    saveOrUpdateTodayCalls++;
    if (todayRecord != null) {
      // Simula atualização mantendo o ID
      todayRecord = WeatherLocalModel.fromWeatherModel(
        weather,
        id: todayRecord!.id,
        cachedAt: DateTime.now(),
      );
    } else {
      // Simula criação de novo registro
      todayRecord = WeatherLocalModel.fromWeatherModel(
        weather,
        cachedAt: DateTime.now(),
      );
    }
    latestRecord = todayRecord;
    return todayRecord!.id;
  }
}

void main() {
  group('WeatherRepository', () {
    test('salva dados da API localmente', () async {
      int apiCalls = 0;
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri _) async {
          apiCalls++;
          return http.Response(jsonEncode(weatherJsonFixture()), 200);
        },
      );

      final bool result = await repository.fetch(-23.5505, -46.6333);

      expect(result, isTrue);
      expect(apiCalls, 1);
      expect(localDataSource.saveOrUpdateTodayCalls, 1);
      final WeatherModel? savedWeather = localDataSource.todayRecord
          ?.toWeatherModel();
      expect(savedWeather?.hourly?.windGusts10m, isNotNull);
      expect(savedWeather?.hourly?.windGusts10m, isNotEmpty);
    });

    test('chama API com parametros corretos de latitude e longitude', () async {
      Uri? capturedUri;
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri uri) async {
          capturedUri = uri;
          return http.Response(jsonEncode(weatherJsonFixture()), 200);
        },
      );

      await repository.fetch(-23.5505, -46.6333);

      expect(capturedUri?.queryParameters['latitude'], '-23.5505');
      expect(capturedUri?.queryParameters['longitude'], '-46.6333');
    });

    test('retorna false quando API falha', () async {
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri _) async => http.Response('error', 500),
      );

      final bool result = await repository.fetch(-23.5505, -46.6333);

      expect(result, isFalse);
      expect(localDataSource.saveCalls, 0);
    });

    test(
      'get retorna o ultimo registro local convertido para WeatherModel',
      () async {
        final localDataSource = _FakeWeatherLocalDataSource(
          latestRecord: WeatherLocalModel(
            id: 1,
            payloadJson: jsonEncode(weatherJsonFixture()),
            cachedAt: DateTime.now(),
          ),
        );

        final repository = WeatherRepository(localRepository: localDataSource);

        final WeatherLocalModel? weather = await repository.get();

        expect(weather, isNotNull);
        expect(weather?.toWeatherModel().latitude, -16.06);
      },
    );

    test('get retorna null quando nao ha registro local', () async {
      final localDataSource = _FakeWeatherLocalDataSource();

      final repository = WeatherRepository(localRepository: localDataSource);

      final result = await repository.get();

      expect(result, isNull);
    });

    test(
      'saveOrUpdateToday cria novo registro quando nao existe de hoje',
      () async {
        int apiCalls = 0;
        final localDataSource = _FakeWeatherLocalDataSource();

        final repository = WeatherRepository(
          localRepository: localDataSource,
          httpGet: (Uri _) async {
            apiCalls++;
            return http.Response(jsonEncode(weatherJsonFixture()), 200);
          },
        );

        final bool result = await repository.fetch(-23.5505, -46.6333);

        expect(result, isTrue);
        expect(apiCalls, 1);
        expect(localDataSource.saveOrUpdateTodayCalls, 1);
        expect(localDataSource.todayRecord, isNotNull);
        expect(
          localDataSource.todayRecord?.id,
          0,
        ); // Novo registro tem ID padrão
      },
    );

    test('saveOrUpdateToday atualiza registro existente de hoje', () async {
      int apiCalls = 0;
      final existingRecord = WeatherLocalModel(
        id: 5,
        payloadJson: jsonEncode(weatherJsonFixture()),
        cachedAt: DateTime.now(),
      );
      final localDataSource = _FakeWeatherLocalDataSource();
      localDataSource.todayRecord = existingRecord;

      final repository = WeatherRepository(
        localRepository: localDataSource,
        httpGet: (Uri _) async {
          apiCalls++;
          return http.Response(
            jsonEncode(<String, dynamic>{
              ...weatherJsonFixture(),
              'current': <String, dynamic>{
                ...weatherJsonFixture()['current'] as Map<String, dynamic>,
                'temperature_2m': 25.5,
              },
            }),
            200,
          );
        },
      );

      final bool result = await repository.fetch(-23.5505, -46.6333);

      expect(result, isTrue);
      expect(localDataSource.saveOrUpdateTodayCalls, 1);
      expect(localDataSource.todayRecord?.id, 5); // Mantém o ID original
      expect(apiCalls, 1);
    });

    test(
      'preserva hourly em cache quando resposta da API nao traz hourly',
      () async {
        final localDataSource = _FakeWeatherLocalDataSource();
        localDataSource.latestRecord = WeatherLocalModel.fromWeatherModel(
          WeatherModel.fromJson(weatherJsonFixture()),
          cachedAt: DateTime.now(),
        );

        final repository = WeatherRepository(
          localRepository: localDataSource,
          httpGet: (Uri _) async {
            final Map<String, dynamic> payloadWithoutHourly =
                Map<String, dynamic>.from(weatherJsonFixture())
                  ..remove('hourly')
                  ..remove('hourly_units');

            return http.Response(jsonEncode(payloadWithoutHourly), 200);
          },
        );

        final bool result = await repository.fetch(-23.5505, -46.6333, false);

        expect(result, isTrue);
        expect(localDataSource.todayRecord, isNotNull);

        final WeatherModel savedWeather = localDataSource.todayRecord!
            .toWeatherModel();
        expect(savedWeather.hourly, isNotNull);
        expect(savedWeather.hourlyUnits, isNotNull);
        expect(savedWeather.hourly?.temperature2m, isNotEmpty);
      },
    );
  });
}

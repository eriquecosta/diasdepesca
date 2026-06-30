import 'package:dias_de_pesca/core/local/models/weather_local_model.dart';
import 'package:dias_de_pesca/core/local/repositories/weather_local_repository.dart';
import 'package:dias_de_pesca/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:objectbox/objectbox.dart';

import '../../fixtures/weather_fixture.dart';

class _MockWeatherBox extends Mock implements Box<WeatherLocalModel> {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      WeatherLocalModel(cachedAt: DateTime(2026, 1, 1), payloadJson: '{}'),
    );
  });

  group('WeatherLocalRepository', () {
    test('save persiste e retorna id', () async {
      final box = _MockWeatherBox();
      when(() => box.put(any())).thenReturn(10);

      final repository = WeatherLocalRepository(box: box);
      final id = await repository.save(weatherModelFixture());

      expect(id, 10);
      verify(() => box.put(any())).called(1);
    });

    test('getLatestRecord retorna null quando nao ha registros', () async {
      final box = _MockWeatherBox();
      when(() => box.getAll()).thenReturn(<WeatherLocalModel>[]);

      final repository = WeatherLocalRepository(box: box);
      final record = await repository.getLatestRecord();

      expect(record, isNull);
    });

    test(
      'getLatestRecord retorna registro mais recente por cachedAt',
      () async {
        final box = _MockWeatherBox();
        final older = WeatherLocalModel.fromWeatherModel(
          weatherModelFixture(),
          id: 1,
          cachedAt: DateTime(2026, 6, 14, 23, 0),
        );
        final newer = WeatherLocalModel.fromWeatherModel(
          weatherModelFixture(),
          id: 2,
          cachedAt: DateTime(2026, 6, 15, 1, 0),
        );
        when(() => box.getAll()).thenReturn(<WeatherLocalModel>[older, newer]);

        final repository = WeatherLocalRepository(box: box);
        final record = await repository.getLatestRecord();

        expect(record?.id, 2);
      },
    );

    test(
      'getLatest retorna WeatherModel convertido do payload local',
      () async {
        final box = _MockWeatherBox();
        final local = WeatherLocalModel.fromWeatherModel(
          weatherModelFixture(),
          id: 3,
          cachedAt: DateTime(2026, 6, 15),
        );
        when(() => box.getAll()).thenReturn(<WeatherLocalModel>[local]);

        final repository = WeatherLocalRepository(box: box);
        final weather = await repository.getLatest();

        expect(weather, isNotNull);
        expect(weather?.timezone, 'GMT');
        expect(weather?.hourly?.time.length, 2);
      },
    );
  });
}

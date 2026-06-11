import 'package:flutter_test/flutter_test.dart';
import 'package:dias_de_pesca/core/moon/moon_service.dart';

void main() {
  group('MoonService', () {
    test('phaseEventsBetween retorna eventos para intervalo jan-mar/2026', () {
      final events = MoonService.phaseEventsBetween(
        DateTime.utc(2026, 1, 1),
        DateTime.utc(2026, 3, 1),
      );

      expect(events, isNotNull);
      expect(events, isA<List<MoonPhaseEvent>>());
      expect(events.length, greaterThan(0));

      // cada evento deve ter instantUtc em UTC e fase válida
      for (final e in events) {
        expect(e.instantUtc.isUtc, isTrue);
        expect(MoonPhase.values.contains(e.phase), isTrue);
      }
    });

    test('phaseEventForLocalDate não lança para data local hoje', () {
      final today = DateTime.now();
      final ev = MoonService.phaseEventForLocalDate(today);
      // pode ser null ou evento válido — apenas garantir que não lança
      if (ev != null) {
        expect(ev.instantUtc.isUtc, isTrue);
        expect(MoonPhase.values.contains(ev.phase), isTrue);
      } else {
        expect(ev, isNull);
      }
    });
  });
}

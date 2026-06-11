import 'package:flutter_test/flutter_test.dart';
import 'package:dias_de_pesca/app/modules/home/home_store.dart';
import 'package:dias_de_pesca/core/moon/moon_service.dart';

void main() {
  test('diagnose good days for displayed month', () {
    final store = HomeStore();
    final displayedMonth = store.displayedMonth;
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    );

    final start = firstOfMonth.subtract(const Duration(days: 7));
    final end = lastOfMonth.add(const Duration(days: 7));

    final events = MoonService.phaseEventsBetween(start.toUtc(), end.toUtc());

    // Normalize event dates to local date-only and group by phase
    final Map<MoonPhase, List<DateTime>> eventsByPhase = {};
    for (final p in MoonPhase.values) eventsByPhase[p] = [];
    for (final ev in events) {
      final local = ev.instantUtc.toLocal();
      final d = DateTime(local.year, local.month, local.day);
      eventsByPhase[ev.phase]!.add(d);
    }
    for (final p in MoonPhase.values) {
      final list = eventsByPhase[p]!;
      final uniq = list.toSet().toList();
      uniq.sort((a, b) => a.compareTo(b));
      eventsByPhase[p] = uniq;
    }

    print(
      '\n--- Diagnóstico de fases (mês: ${displayedMonth.year}-${displayedMonth.month}) ---',
    );
    for (final p in MoonPhase.values) {
      final label = p.toString().split('.').last;
      print('\nPhase: $label');
      for (final d in eventsByPhase[p]!) {
        print(
          '  - ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
        );
      }
    }

    final goodDays =
        store.calendarDays
            .where((d) => d.quality == FishingQuality.good)
            .toList();
    goodDays.sort((a, b) => a.date.compareTo(b.date));

    print('\nMarked GOOD days:');
    for (final gd in goodDays) {
      final d = gd.date;
      print(
        '  - ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} (phaseChange: ${gd.isPhaseChange})',
      );
    }

    final badDays =
        store.calendarDays
            .where((d) => d.quality == FishingQuality.bad)
            .toList();
    badDays.sort((a, b) => a.date.compareTo(b.date));
    print('\nMarked BAD days:');
    for (final bd in badDays) {
      final d = bd.date;
      print(
        '  - ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} (phaseChange: ${bd.isPhaseChange})',
      );
    }
    final intermediateDays =
        store.calendarDays
            .where((d) => d.quality == FishingQuality.intermediate)
            .toList();
    intermediateDays.sort((a, b) => a.date.compareTo(b.date));
    print('\nMarked INTERMEDIATE days:');
    for (final id in intermediateDays) {
      final d = id.date;
      print(
        '  - ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} (phaseChange: ${id.isPhaseChange})',
      );
    }

    // Keep the test passing
    expect(true, isTrue);
  });
}

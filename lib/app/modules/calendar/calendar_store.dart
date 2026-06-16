import 'package:mobx/mobx.dart';
import 'package:dias_de_pesca/core/moon/moon_service.dart';

part 'calendar_store.g.dart';

// ignore: library_private_types_in_public_api
class CalendarStore = _CalendarStoreBase with _$CalendarStore;

abstract class _CalendarStoreBase with Store {
  static const List<String> monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  _CalendarStoreBase() {
    final now = DateTime.now();
    displayedMonth = DateTime(now.year, now.month, 1);
    currentDate = DateTime(now.year, now.month, now.day);
  }

  @observable
  late DateTime displayedMonth;

  @observable
  late DateTime currentDate;

  @computed
  String get monthLabel =>
      '${monthNames[displayedMonth.month - 1]} ${displayedMonth.year}';

  @computed
  List<CalendarDay> get calendarDays {
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final startDayOffset = firstOfMonth.weekday % 7;
    final daysInMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
    final totalDays = ((startDayOffset + daysInMonth + 6) ~/ 7) * 7;
    final firstDisplayDate = firstOfMonth.subtract(
      Duration(days: startDayOffset),
    );
    final lastDisplayDate = firstDisplayDate.add(Duration(days: totalDays - 1));

    final phaseEvents = MoonService.phaseEventsBetween(
      firstDisplayDate.toUtc().subtract(const Duration(days: 1)),
      lastDisplayDate.toUtc().add(const Duration(days: 1)),
    );
    final eventDays =
        phaseEvents.map((event) {
          final local = event.instantUtc.toLocal();
          return DateTime(local.year, local.month, local.day);
        }).toSet();

    // Map local date -> phase for quick lookups
    final Map<DateTime, MoonPhase> eventByLocalDate = {};
    for (final ev in phaseEvents) {
      final local = ev.instantUtc.toLocal();
      final d = DateTime(local.year, local.month, local.day);
      eventByLocalDate.putIfAbsent(d, () => ev.phase);
    }

    // Helper to add ranges of dates to sets
    DateTime dd(DateTime base, int offset) {
      return DateTime(
        base.year,
        base.month,
        base.day,
      ).add(Duration(days: offset));
    }

    final Set<DateTime> good = {};
    final Set<DateTime> bad = {};

    // Collect phase event dates grouped by phase (date-only), deduplicated and sorted
    final eventsByPhase = <MoonPhase, List<DateTime>>{};
    for (final phase in MoonPhase.values) {
      eventsByPhase[phase] = [];
    }
    for (final ev in phaseEvents) {
      final local = ev.instantUtc.toLocal();
      final d = DateTime(local.year, local.month, local.day);
      eventsByPhase[ev.phase]!.add(d);
    }
    // Deduplicate and sort each phase list
    for (final phase in MoonPhase.values) {
      final list = eventsByPhase[phase]!;
      final uniq = list.toSet().toList();
      uniq.sort((a, b) {
        if (a.year != b.year) return a.year.compareTo(b.year);
        if (a.month != b.month) return a.month.compareTo(b.month);
        return a.day.compareTo(b.day);
      });
      eventsByPhase[phase] = uniq;
    }

    // GOOD rules (new requirements)
    // 1) First period: from lastQuarter (Lua Minguante) up to (newMoon - 3 days)
    for (final d in eventsByPhase[MoonPhase.lastQuarter] ?? []) {
      final nextNew = (eventsByPhase[MoonPhase.newMoon] ?? []).firstWhere(
        (nd) => nd.isAfter(d),
        orElse: () => dd(d, 30),
      );
      final start = d;
      final end = dd(nextNew, -3);
      for (
        var cur = start;
        !cur.isAfter(end);
        cur = cur.add(const Duration(days: 1))
      ) {
        good.add(cur);
      }
    }

    // 2) Second period: from firstQuarter (Crescente) up to (fullMoon - 4 days)
    for (final d in eventsByPhase[MoonPhase.firstQuarter] ?? []) {
      final nextFull = (eventsByPhase[MoonPhase.fullMoon] ?? []).firstWhere(
        (fd) => fd.isAfter(d),
        orElse: () => dd(d, 30),
      );
      final start = d;
      final end = dd(nextFull, -4);
      for (
        var cur = start;
        !cur.isAfter(end);
        cur = cur.add(const Duration(days: 1))
      ) {
        good.add(cur);
      }
    }

    // BAD rules
    // For each full moon: from fullMoon - 3 to fullMoon + 2
    for (final d in eventsByPhase[MoonPhase.fullMoon] ?? []) {
      final start = dd(d, -3);
      final end = dd(d, 2);
      for (
        var cur = start;
        !cur.isAfter(end);
        cur = cur.add(const Duration(days: 1))
      ) {
        bad.add(cur);
      }
    }

    // Additional BAD rule: for each new moon, from newMoon +3 to newMoon +4
    for (final d in eventsByPhase[MoonPhase.newMoon] ?? []) {
      for (var i = 3; i <= 4; i++) {
        bad.add(dd(d, i));
      }
    }

    // Build a map date -> quality (only good days for now)
    final Map<DateTime, FishingQuality> qualityMap = {};
    for (final d in good) {
      qualityMap[d] = FishingQuality.good;
    }
    // Apply bad days with precedence over good
    for (final d in bad) {
      qualityMap[d] = FishingQuality.bad;
    }

    // INTERMEDIATE: mark any date within the display range that is not yet marked
    final startDisplay = DateTime(
      firstDisplayDate.year,
      firstDisplayDate.month,
      firstDisplayDate.day,
    );
    final endDisplay = DateTime(
      lastDisplayDate.year,
      lastDisplayDate.month,
      lastDisplayDate.day,
    );
    for (
      var cur = startDisplay;
      !cur.isAfter(endDisplay);
      cur = cur.add(const Duration(days: 1))
    ) {
      if (!qualityMap.containsKey(cur)) {
        qualityMap[cur] = FishingQuality.intermediate;
      }
    }

    // Note: do not remove current date — current day should be marked when applicable

    return List<CalendarDay>.generate(totalDays, (index) {
      final date = firstDisplayDate.add(Duration(days: index));
      final phase = MoonService.phaseForDate(date);
      final localDate = DateTime(date.year, date.month, date.day);
      final isPhaseChange = eventDays.contains(localDate);
      final quality = qualityMap[localDate] ?? FishingQuality.none;
      return CalendarDay(
        date: date,
        isInCurrentMonth: date.month == displayedMonth.month,
        phase: phase,
        isPhaseChange: isPhaseChange,
        quality: quality,
      );
    });
  }

  bool isToday(DateTime date) {
    return date.year == currentDate.year &&
        date.month == currentDate.month &&
        date.day == currentDate.day;
  }

  @action
  void moveToPreviousMonth() {
    displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1, 1);
  }

  @action
  void moveToNextMonth() {
    displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 1);
  }

  @action
  void goToCurrentMonth() {
    displayedMonth = DateTime(currentDate.year, currentDate.month, 1);
  }
}

class CalendarDay {
  final DateTime date;
  final bool isInCurrentMonth;
  final MoonPhase phase;
  final bool isPhaseChange;
  final FishingQuality quality;

  CalendarDay({
    required this.date,
    required this.isInCurrentMonth,
    required this.phase,
    required this.isPhaseChange,
    this.quality = FishingQuality.none,
  });
}

enum FishingQuality { none, bad, intermediate, good }

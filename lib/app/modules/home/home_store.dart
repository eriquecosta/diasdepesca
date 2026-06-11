import 'package:mobx/mobx.dart';
import 'package:dias_de_pesca/core/moon/moon_service.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
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

  _HomeStoreBase() {
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

    return List<CalendarDay>.generate(totalDays, (index) {
      final date = firstDisplayDate.add(Duration(days: index));
      final phase = MoonService.phaseForDate(date);
      final localDate = DateTime(date.year, date.month, date.day);
      final isPhaseChange = eventDays.contains(localDate);
      return CalendarDay(
        date: date,
        isInCurrentMonth: date.month == displayedMonth.month,
        phase: phase,
        isPhaseChange: isPhaseChange,
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

  CalendarDay({
    required this.date,
    required this.isInCurrentMonth,
    required this.phase,
    required this.isPhaseChange,
  });
}

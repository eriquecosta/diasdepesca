// ignore_for_file: avoid_print

import 'package:dias_de_pesca/core/moon/moon_service.dart';

void main() {
  final start = DateTime.utc(2025, 12, 25);
  final end = DateTime.utc(2026, 2, 15);
  final events = MoonService.phaseEventsBetween(start, end);
  print('events count=${events.length}');
  for (final event in events) {
    final local = event.instantUtc.toLocal();
    print(
      '${event.phase}: ${event.instantUtc.toIso8601String()} UTC | ${local.toString()} LOCAL',
    );
  }
}

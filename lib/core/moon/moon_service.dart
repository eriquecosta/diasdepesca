import 'dart:math' as math;

enum MoonPhase { newMoon, firstQuarter, fullMoon, lastQuarter }

class MoonPhaseEvent {
  final DateTime instantUtc;
  final MoonPhase phase;

  MoonPhaseEvent(this.instantUtc, this.phase);
}

class MoonService {
  MoonService._();

  static const double _synodicMonth = 29.53058867;

  /// Retorna a fase lunar para uma data.
  /// Implementação aproximada — suficiente para marcações visuais.
  static MoonPhase phaseForDate(DateTime date) {
    final age = _moonAge(date);
    final quarter = _synodicMonth / 4.0; // ~7.3826

    if (age < quarter / 2 || age > _synodicMonth - quarter / 2) {
      return MoonPhase.newMoon;
    }
    if ((age - quarter).abs() < quarter / 2) {
      return MoonPhase.firstQuarter;
    }
    if ((age - 2 * quarter).abs() < quarter / 2) {
      return MoonPhase.fullMoon;
    }
    if ((age - 3 * quarter).abs() < quarter / 2) {
      return MoonPhase.lastQuarter;
    }

    final distances = {
      MoonPhase.newMoon: _dist(age, 0),
      MoonPhase.firstQuarter: _dist(age, quarter),
      MoonPhase.fullMoon: _dist(age, 2 * quarter),
      MoonPhase.lastQuarter: _dist(age, 3 * quarter),
    };
    return distances.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  /// Retorna as fases para cada dia do mês de [forMonth] (primeiro dia do mês considerado).
  static List<MoonPhase> phasesForMonth(DateTime forMonth) {
    final firstOfMonth = DateTime(forMonth.year, forMonth.month, 1);
    final days = DateTime(forMonth.year, forMonth.month + 1, 0).day;
    return List.generate(
      days,
      (i) => phaseForDate(firstOfMonth.add(Duration(days: i))),
    );
  }

  /// Retorna os instantes UTC de fases lunares dentro do intervalo.
  static List<MoonPhaseEvent> phaseEventsBetween(
    DateTime startUtc,
    DateTime endUtc,
  ) {
    final normalizedStart = startUtc.toUtc();
    final normalizedEnd = endUtc.toUtc();
    final startK = _phaseIndexForDateUtc(normalizedStart) - 2;
    final endK = _phaseIndexForDateUtc(normalizedEnd) + 2;

    final events = <MoonPhaseEvent>[];
    for (var k = startK; k <= endK; k++) {
      for (final phase in MoonPhase.values) {
        final instantUtc = _phaseInstantUtc(k, phase);
        if (instantUtc.isAfter(
              normalizedStart.subtract(const Duration(days: 1)),
            ) &&
            instantUtc.isBefore(normalizedEnd.add(const Duration(days: 1)))) {
          events.add(MoonPhaseEvent(instantUtc, phase));
        }
      }
    }

    events.sort((a, b) => a.instantUtc.compareTo(b.instantUtc));
    return events;
  }

  /// Retorna o evento de fase lunar que ocorre na [localDate] (data local),
  /// ou `null` se nenhum evento cair nesse dia local.
  static MoonPhaseEvent? phaseEventForLocalDate(DateTime localDate) {
    final startLocal = DateTime(localDate.year, localDate.month, localDate.day);
    final endLocal = startLocal.add(const Duration(days: 1));

    final events = phaseEventsBetween(
      startLocal.toUtc().subtract(const Duration(hours: 1)),
      endLocal.toUtc().add(const Duration(hours: 1)),
    );

    for (final ev in events) {
      final evLocal = ev.instantUtc.toLocal();
      if (evLocal.year == localDate.year &&
          evLocal.month == localDate.month &&
          evLocal.day == localDate.day) {
        return ev;
      }
    }
    return null;
  }

  static DateTime _phaseInstantUtc(int kBase, MoonPhase phase) {
    final k = kBase + _phaseFraction(phase);
    final t = k / 1236.85;
    final t2 = t * t;
    final t3 = t2 * t;
    final t4 = t2 * t2;

    final jde0 =
        2451550.09766 +
        29.530588861 * k +
        0.00015437 * t2 -
        0.000000150 * t3 +
        0.00000000073 * t4;

    final m = _normalizeAngle(
      2.5534 + 29.10535669 * k - 0.0000218 * t2 - 0.00000011 * t3,
    );
    final mPrime = _normalizeAngle(
      201.5643 +
          385.81693528 * k +
          0.0107438 * t2 +
          0.00001239 * t3 -
          0.000000058 * t4,
    );
    final f = _normalizeAngle(
      160.7108 +
          390.67050274 * k -
          0.0016341 * t2 -
          0.00000227 * t3 +
          0.000000011 * t4,
    );
    final omega = _normalizeAngle(
      124.7746 - 1.56375588 * k + 0.0020672 * t2 + 0.00000215 * t3,
    );
    final e = 1 - 0.002516 * t - 0.0000074 * t2;

    var deltaJde = 0.0;
    if (phase == MoonPhase.newMoon) {
      deltaJde =
          -0.40720 * _sinDeg(mPrime) +
          0.17241 * e * _sinDeg(m) +
          0.01608 * _sinDeg(2 * mPrime) +
          0.01039 * _sinDeg(2 * f) +
          0.00739 * e * _sinDeg(mPrime - m) -
          0.00514 * e * _sinDeg(mPrime + m) +
          0.00208 * e * e * _sinDeg(2 * m) -
          0.00111 * _sinDeg(mPrime - 2 * f) -
          0.00057 * _sinDeg(mPrime + 2 * f) +
          0.00056 * e * _sinDeg(2 * mPrime + m) -
          0.00042 * _sinDeg(3 * mPrime) +
          0.00042 * e * _sinDeg(m + 2 * f) +
          0.00038 * e * _sinDeg(m - 2 * f) -
          0.00024 * _sinDeg(2 * mPrime - m) -
          0.00017 * _sinDeg(omega) -
          0.00007 * _sinDeg(mPrime + 2 * m) +
          0.00004 * _sinDeg(2 * mPrime - 2 * f) +
          0.00004 * _sinDeg(3 * m) +
          0.00003 * _sinDeg(mPrime + 2 * f) +
          0.00003 * _sinDeg(2 * mPrime + 2 * f) -
          0.00003 * _sinDeg(mPrime + 2 * m - 2 * f) +
          0.00003 * _sinDeg(mPrime + 2 * m + 2 * f) -
          0.00002 * _sinDeg(mPrime - 2 * m - 2 * f) -
          0.00002 * _sinDeg(3 * mPrime + m) +
          0.00002 * _sinDeg(4 * mPrime);
    } else if (phase == MoonPhase.fullMoon) {
      deltaJde =
          -0.40614 * _sinDeg(mPrime) +
          0.17302 * e * _sinDeg(m) +
          0.01614 * _sinDeg(2 * mPrime) +
          0.01043 * _sinDeg(2 * f) +
          0.00734 * e * _sinDeg(mPrime - m) -
          0.00515 * e * _sinDeg(mPrime + m) +
          0.00209 * e * e * _sinDeg(2 * m) -
          0.00111 * _sinDeg(mPrime - 2 * f) -
          0.00057 * _sinDeg(mPrime + 2 * f) +
          0.00056 * e * _sinDeg(2 * mPrime + m) -
          0.00042 * _sinDeg(3 * mPrime) +
          0.00042 * e * _sinDeg(m + 2 * f) +
          0.00038 * e * _sinDeg(m - 2 * f) -
          0.00024 * _sinDeg(2 * mPrime - m) -
          0.00017 * _sinDeg(omega) -
          0.00007 * _sinDeg(mPrime + 2 * m) +
          0.00004 * _sinDeg(2 * mPrime - 2 * f) +
          0.00004 * _sinDeg(3 * m) +
          0.00003 * _sinDeg(mPrime + 2 * f) +
          0.00003 * _sinDeg(2 * mPrime + 2 * f) -
          0.00003 * _sinDeg(mPrime + 2 * m - 2 * f) +
          0.00003 * _sinDeg(mPrime + 2 * m + 2 * f) -
          0.00002 * _sinDeg(mPrime - 2 * m - 2 * f) -
          0.00002 * _sinDeg(3 * mPrime + m) +
          0.00002 * _sinDeg(4 * mPrime);
    } else {
      deltaJde =
          -0.62801 * _sinDeg(mPrime) +
          0.17172 * e * _sinDeg(m) -
          0.01183 * e * _sinDeg(mPrime + m) +
          0.00862 * _sinDeg(2 * mPrime) +
          0.00804 * _sinDeg(2 * f) +
          0.00454 * e * _sinDeg(mPrime - m) +
          0.00204 * e * e * _sinDeg(2 * m) -
          0.00180 * _sinDeg(mPrime - 2 * f) -
          0.00070 * _sinDeg(mPrime + 2 * f) -
          0.00040 * _sinDeg(3 * mPrime) -
          0.00034 * e * _sinDeg(2 * mPrime - m) +
          0.00032 * e * _sinDeg(m + 2 * f) +
          0.00032 * e * _sinDeg(m - 2 * f) -
          0.00028 * e * e * _sinDeg(mPrime + 2 * m) +
          0.00027 * e * _sinDeg(2 * mPrime + m) -
          0.00017 * _sinDeg(omega);

      final w =
          phase == MoonPhase.firstQuarter
              ? 0.0028 - 0.0004 * _cosDeg(m) + 0.0003 * _cosDeg(mPrime)
              : -0.0028 + 0.0004 * _cosDeg(m) - 0.0003 * _cosDeg(mPrime);
      deltaJde += w;
    }

    final jde = jde0 + deltaJde;
    final deltaTSeconds = _deltaT(2000.0 + k / 12.3685);
    final utcJd = jde - deltaTSeconds / 86400.0;
    return _dateTimeFromJulianDate(utcJd);
  }

  static double _phaseFraction(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return 0.0;
      case MoonPhase.firstQuarter:
        return 0.25;
      case MoonPhase.fullMoon:
        return 0.5;
      case MoonPhase.lastQuarter:
        return 0.75;
    }
  }

  static int _phaseIndexForDateUtc(DateTime utc) {
    final year = utc.year + (utc.month - 0.5) / 12.0;
    return ((year - 2000.0) * 12.3685).floor();
  }

  static DateTime _dateTimeFromJulianDate(double jd) {
    final julian = jd + 0.5;
    final z = julian.floorToDouble();
    final f = julian - z;
    var a = z;
    if (z >= 2299161) {
      final alpha = ((z - 1867216.25) / 36524.25).floorToDouble();
      a = z + 1 + alpha - (alpha / 4).floorToDouble();
    }

    final b = a + 1524;
    final c = ((b - 122.1) / 365.25).floorToDouble();
    final d = (365.25 * c).floorToDouble();
    final e = ((b - d) / 30.6001).floorToDouble();
    final day = b - d - (30.6001 * e).floorToDouble() + f;
    final month = e < 14 ? (e - 1).toInt() : (e - 13).toInt();
    final year = month > 2 ? (c - 4716).toInt() : (c - 4715).toInt();

    final dayInt = day.floor();
    final dayFraction = day - dayInt;
    final totalSeconds = (dayFraction * 86400).round();
    final hour = totalSeconds ~/ 3600;
    final minute = (totalSeconds % 3600) ~/ 60;
    final second = totalSeconds % 60;

    return DateTime.utc(year, month, dayInt, hour, minute, second);
  }

  static double _moonaAge(DateTime date) {
    final reference = DateTime.utc(2000, 1, 6, 18, 14);
    final diff = date.toUtc().difference(reference).inSeconds / 86400.0;
    double age = diff % _synodicMonth;
    if (age < 0) age += _synodicMonth;
    return age;
  }

  static double _moonAge(DateTime date) {
    return _moonaAge(date);
  }

  static double _dist(double a, double b) {
    final d = (a - b).abs();
    return d;
  }

  static double _normalizeAngle(double degrees) {
    return degrees - 360.0 * (degrees / 360.0).floorToDouble();
  }

  static double _sinDeg(double degrees) {
    return math.sin(degrees * math.pi / 180.0);
  }

  static double _cosDeg(double degrees) {
    return math.cos(degrees * math.pi / 180.0);
  }

  static double _deltaT(double year) {
    final t = (year - 2000.0) / 100.0;
    return 102.0 + 102.0 * t + 25.3 * t * t;
  }
}

import 'package:flutter/material.dart';
import 'home_store.dart';
import 'package:dias_de_pesca/core/moon/moon_service.dart';

class HomeDayCard extends StatelessWidget {
  final CalendarDay day;
  final bool isToday;

  const HomeDayCard({super.key, required this.day, required this.isToday});

  String _assetForPhase(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return 'assets/lua_nova.png';
      case MoonPhase.firstQuarter:
        return 'assets/lua_crescente.png';
      case MoonPhase.fullMoon:
        return 'assets/lua_cheia.png';
      case MoonPhase.lastQuarter:
        return 'assets/lua_minguante.png';
    }
  }

  String _labelForPhase(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return 'Lua Nova';
      case MoonPhase.firstQuarter:
        return 'Crescente';
      case MoonPhase.fullMoon:
        return 'Lua Cheia';
      case MoonPhase.lastQuarter:
        return 'Minguante';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Remove special highlight for today — current day must be unmarked
    final defaultTextColor =
        day.isInCurrentMonth
            ? colorScheme.onSurface
            : colorScheme.onSurface.withAlpha(115);
    final dayTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: defaultTextColor,
      fontWeight: FontWeight.w500,
    );

    Color backgroundColor =
        day.isInCurrentMonth ? colorScheme.surface : Colors.transparent;

    // Apply classification colors
    double opacity = day.isPhaseChange ? 1.0 : 0.5;
    Color? classificationColor;
    Color textColor = defaultTextColor;
    switch (day.quality) {
      case FishingQuality.bad:
        classificationColor = const Color(0xFFFF2400);
        textColor = Colors.white;
        break;
      case FishingQuality.intermediate:
        classificationColor = const Color(0xFFFFA500);
        textColor = Colors.white;
        break;
      case FishingQuality.good:
        classificationColor = const Color(0xFF52CC02);
        textColor = Colors.white;
        break;
      case FishingQuality.none:
        classificationColor = null;
        break;
    }
    if (classificationColor != null) {
      backgroundColor = classificationColor.withOpacity(opacity);
    }

    Widget child = Text(
      '${day.date.day}',
      style: dayTextStyle?.copyWith(color: textColor),
    );

    if (day.isPhaseChange) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${day.date.day}',
            style: dayTextStyle?.copyWith(color: textColor),
          ),
          const SizedBox(height: 6),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              _assetForPhase(day.phase),
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap:
          day.isPhaseChange
              ? () {
                final ev = MoonService.phaseEventForLocalDate(day.date);
                String message;
                if (ev == null) {
                  message = 'Horário não disponível';
                } else {
                  final local = ev.instantUtc.toLocal();
                  String two(int n) => n.toString().padLeft(2, '0');
                  message =
                      '${two(local.day)}/${two(local.month)}/${local.year} '
                      '${two(local.hour)}:${two(local.minute)}';
                }

                showDialog<void>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: Text('${_labelForPhase(day.phase)}'),
                        content: Text(message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                );
              }
              : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

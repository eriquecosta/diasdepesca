import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_day_card.dart';
import 'home_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> weekdayLabels = [
    'Dom',
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
  ];

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HomeStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dias de Pesca')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Observer(
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: store.moveToPreviousMonth,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          store.monthLabel,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: store.moveToNextMonth,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children:
                          weekdayLabels
                              .map(
                                (label) => Expanded(
                                  child: Center(
                                    child: Text(
                                      label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    AspectRatio(
                      aspectRatio: 7 / 6,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: store.calendarDays.length,
                        itemBuilder: (context, index) {
                          final day = store.calendarDays[index];
                          final isToday = store.isToday(day.date);
                          return HomeDayCard(day: day, isToday: isToday);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: const [
                        _LegendItem(
                          asset: 'assets/lua_nova.png',
                          label: 'Lua Nova',
                        ),
                        _LegendItem(
                          asset: 'assets/lua_crescente.png',
                          label: 'Crescente',
                        ),
                        _LegendItem(
                          asset: 'assets/lua_cheia.png',
                          label: 'Lua Cheia',
                        ),
                        _LegendItem(
                          asset: 'assets/lua_minguante.png',
                          label: 'Minguante',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: store.goToCurrentMonth,
                        child: const Text('Hoje'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String asset;
  final String label;

  const _LegendItem({required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: Image.asset(asset, width: 16, height: 16, fit: BoxFit.contain),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

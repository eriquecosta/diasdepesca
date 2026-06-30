import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Gráfico de linha para temperatura horária
class TemperatureChart extends StatelessWidget {
  final List<double> temperatures;
  final List<String> times;
  final String unit;

  const TemperatureChart({
    required this.temperatures,
    required this.times,
    required this.unit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (temperatures.isEmpty || times.isEmpty) {
      return const Center(child: Text('Sem dados de temperatura'));
    }

    // Pegar apenas as primeiras 24 horas
    final hourlyTemps = temperatures.take(24).toList();
    final hourlyTimes = times.take(24).toList();

    final spots = <FlSpot>[];
    for (int i = 0; i < hourlyTemps.length; i++) {
      spots.add(FlSpot(i.toDouble(), hourlyTemps[i]));
    }

    final double minTemp = hourlyTemps.reduce((a, b) => a < b ? a : b);
    final double maxTemp = hourlyTemps.reduce((a, b) => a > b ? a : b);
    final double minY = minTemp >= 5 ? 0 : minTemp - 5;
    final double maxY = maxTemp < 35 ? 40 : maxTemp + 5;

    String hourLabelAt(int index) {
      final time = hourlyTimes[index];
      return time.split('T').last.substring(0, 5);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double visiblePoints = 7;
          const double edgePadding = 12;
          final double pointSpacing = constraints.maxWidth / visiblePoints;
          final double desiredWidth = pointSpacing * hourlyTemps.length;
          final double chartWidth = desiredWidth < constraints.maxWidth
              ? constraints.maxWidth
              : desiredWidth;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: edgePadding),
              child: SizedBox(
                width: chartWidth,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: false,
                      verticalInterval: 1,
                      getDrawingVerticalLine: (double value) {
                        return FlLine(
                          color: Colors.black26,
                          strokeWidth: 1,
                          dashArray: <int>[4, 4],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            if (value % 1 != 0 ||
                                index < 0 ||
                                index >= hourlyTimes.length) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                hourLabelAt(index),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            if (value % 1 != 0 ||
                                index < 0 ||
                                index >= hourlyTemps.length) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              '${hourlyTemps[index].round()}°',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: <LineChartBarData>[
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter:
                              (
                                FlSpot spot,
                                double xPercentage,
                                LineChartBarData bar,
                                int index,
                              ) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: Colors.blue,
                                  strokeWidth: 0,
                                );
                              },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withValues(alpha: 0.16),
                        ),
                      ),
                    ],
                    minX: -0.5,
                    maxX: (hourlyTemps.length - 1).toDouble() + 0.5,
                    minY: minY,
                    maxY: maxY,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Gráfico de colunas para precipitação e probabilidade horária com rolagem
class PrecipitationChart extends StatelessWidget {
  final List<double> precipitation;
  final List<double> probability;
  final List<String> times;
  final String precipitationUnit;
  final String probabilityUnit;

  const PrecipitationChart({
    required this.precipitation,
    required this.probability,
    required this.times,
    required this.precipitationUnit,
    required this.probabilityUnit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (precipitation.isEmpty || probability.isEmpty || times.isEmpty) {
      return const Center(child: Text('Sem dados de precipitação'));
    }

    final List<double> hourlyPrecip = precipitation.take(24).toList();
    final List<double> hourlyProb = probability.take(24).toList();
    final List<String> hourlyTimes = times.take(24).toList();

    final double maxPrecip = hourlyPrecip.reduce((a, b) => a > b ? a : b);
    final double effectiveMax = maxPrecip < 2 ? 2 : maxPrecip + 2;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double visiblePoints = 7;
        const double edgePadding = 8;
        final double columnWidth = constraints.maxWidth / visiblePoints;
        const double barAreaHeight = 100.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: columnWidth * hourlyTimes.length + (edgePadding * 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: edgePadding),
                ...List.generate(hourlyTimes.length, (int i) {
                  final String hour = hourlyTimes[i]
                      .split('T')
                      .last
                      .substring(0, 5);
                  final double precip = hourlyPrecip[i];
                  final double prob = hourlyProb[i];
                  final double barFraction = (precip / effectiveMax).clamp(
                    0.0,
                    1.0,
                  );

                  return SizedBox(
                    width: columnWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Área da barra proporcional à precipitação
                        SizedBox(
                          height: barAreaHeight,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: columnWidth * 0.44,
                              height: barFraction > 0
                                  ? barAreaHeight * barFraction
                                  : 4,
                              decoration: BoxDecoration(
                                color: precip > 0
                                    ? Colors.blue.shade400
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Valor de precipitação
                        Text(
                          precip.toStringAsFixed(1).replaceAll('.', ','),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        Text(
                          precipitationUnit,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Badge de probabilidade
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${prob.toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Hora
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            hour,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: i == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: edgePadding),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Gráfico de linhas para velocidade do vento e rajadas horárias com rolagem
/// Converte graus para abreviação de direção cardeal (N, NNE, NE, ...).
String _degreesToCardinal(double degrees) {
  const List<String> directions = [
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSO',
    'SO',
    'OSO',
    'O',
    'ONO',
    'NO',
    'NNO',
  ];
  final int index = ((degrees % 360) / 22.5).round() % 16;
  return directions[index];
}

class WindChart extends StatefulWidget {
  final List<double> windSpeeds;
  final List<double> windGusts;
  final List<double> windDirections;
  final List<String> times;
  final String unit;
  final String? gustUnit;

  const WindChart({
    required this.windSpeeds,
    required this.windGusts,
    required this.windDirections,
    required this.times,
    required this.unit,
    this.gustUnit,
    super.key,
  });

  @override
  State<WindChart> createState() => _WindChartState();
}

class _WindChartState extends State<WindChart> {
  bool _showGustValues = false;

  @override
  Widget build(BuildContext context) {
    if (widget.windSpeeds.isEmpty || widget.times.isEmpty) {
      return const Center(child: Text('Sem dados de vento'));
    }

    final List<double> hourlyWind = widget.windSpeeds.take(24).toList();
    final List<double> hourlyGusts = widget.windGusts.take(24).toList();
    final List<double> hourlyDirs = widget.windDirections.take(24).toList();
    final List<String> hourlyTimes = widget.times.take(24).toList();

    final List<FlSpot> speedSpots = <FlSpot>[
      for (int i = 0; i < hourlyWind.length; i++)
        FlSpot(i.toDouble(), hourlyWind[i]),
    ];

    final bool hasGusts = hourlyGusts.isNotEmpty;
    final List<FlSpot> gustSpots = <FlSpot>[
      for (int i = 0; i < hourlyGusts.length; i++)
        FlSpot(i.toDouble(), hourlyGusts[i]),
    ];

    final double maxVal = <double>[
      ...hourlyWind,
      if (hasGusts) ...hourlyGusts,
    ].reduce((a, b) => a > b ? a : b);
    final double maxY = maxVal < 30 ? 30 : maxVal + 5;
    final bool showGustValues = _showGustValues && hasGusts;
    final Color activeValueColor = showGustValues
        ? Colors.amber.shade700
        : Colors.blue.shade700;

    String hourLabelAt(int index) =>
        hourlyTimes[index].split('T').last.substring(0, 5);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          // Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _WindLegendDot(
                color: Colors.blue,
                label: 'Velocidade (${widget.unit})',
              ),
              if (hasGusts) ...<Widget>[
                const SizedBox(width: 16),
                _WindLegendDot(
                  color: Colors.amber.shade400,
                  label: 'Rajadas (${widget.gustUnit ?? widget.unit})',
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double visiblePoints = 7;
                const double edgePadding = 12;
                final double pointSpacing =
                    constraints.maxWidth / visiblePoints;
                final double desiredWidth = pointSpacing * hourlyTimes.length;
                final double chartWidth = desiredWidth < constraints.maxWidth
                    ? constraints.maxWidth
                    : desiredWidth;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: hasGusts
                      ? () {
                          setState(() {
                            _showGustValues = !_showGustValues;
                          });
                        }
                      : null,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: edgePadding,
                      ),
                      child: SizedBox(
                        width: chartWidth,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: false,
                              verticalInterval: 1,
                              getDrawingVerticalLine: (_) => FlLine(
                                color: Colors.black26,
                                strokeWidth: 1,
                                dashArray: <int>[4, 4],
                              ),
                            ),
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                axisNameSize: 0,
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                        final int index = value.toInt();
                                        if (value % 1 != 0 ||
                                            index < 0 ||
                                            index >= hourlyWind.length) {
                                          return const SizedBox.shrink();
                                        }
                                        final String cardinal =
                                            index < hourlyDirs.length
                                            ? _degreesToCardinal(
                                                hourlyDirs[index],
                                              )
                                            : '';
                                        final double valueLabel =
                                            showGustValues &&
                                                index < hourlyGusts.length
                                            ? hourlyGusts[index]
                                            : hourlyWind[index];
                                        return SizedBox(
                                          height: 36,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                valueLabel
                                                    .toStringAsFixed(1)
                                                    .replaceAll('.', ','),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: activeValueColor,
                                                ),
                                              ),
                                              if (cardinal.isNotEmpty)
                                                Text(
                                                  cardinal,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue.shade400,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                        final int index = value.toInt();
                                        if (value % 1 != 0 ||
                                            index < 0 ||
                                            index >= hourlyTimes.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            hourLabelAt(index),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: <LineChartBarData>[
                              if (hasGusts)
                                LineChartBarData(
                                  spots: gustSpots,
                                  isCurved: true,
                                  color: Colors.amber.shade400,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                ),
                              LineChartBarData(
                                spots: speedSpots,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (
                                        FlSpot spot,
                                        double pct,
                                        LineChartBarData bar,
                                        int index,
                                      ) => FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.blue,
                                        strokeWidth: 0,
                                      ),
                                ),
                              ),
                            ],
                            minX: -0.5,
                            maxX: (hourlyTimes.length - 1).toDouble() + 0.5,
                            minY: 0,
                            maxY: maxY,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WindLegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _WindLegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// Gráfico de linha para pressão atmosférica horária
class PressureChart extends StatelessWidget {
  final List<double> pressures;
  final List<String> times;
  final String unit;

  const PressureChart({
    required this.pressures,
    required this.times,
    required this.unit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (pressures.isEmpty || times.isEmpty) {
      return const Center(child: Text('Sem dados de pressão'));
    }

    final hourlyPressure = pressures.take(24).toList();
    final hourlyTimes = times.take(24).toList();

    final spots = <FlSpot>[];
    for (int i = 0; i < hourlyPressure.length; i++) {
      spots.add(FlSpot(i.toDouble(), hourlyPressure[i]));
    }

    final double minPressure = hourlyPressure.reduce((a, b) => a < b ? a : b);
    final double maxPressure = hourlyPressure.reduce((a, b) => a > b ? a : b);
    final double minY = minPressure - 10;
    final double maxY = maxPressure + 10;

    String hourLabelAt(int index) {
      final time = hourlyTimes[index];
      return time.split('T').last.substring(0, 5);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double visiblePoints = 7;
          const double edgePadding = 12;
          final double pointSpacing = constraints.maxWidth / visiblePoints;
          final double desiredWidth = pointSpacing * hourlyPressure.length;
          final double chartWidth = desiredWidth < constraints.maxWidth
              ? constraints.maxWidth
              : desiredWidth;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: edgePadding),
              child: SizedBox(
                width: chartWidth,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: false,
                      verticalInterval: 1,
                      getDrawingVerticalLine: (double value) {
                        return FlLine(
                          color: Colors.black26,
                          strokeWidth: 1,
                          dashArray: <int>[4, 4],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            if (value % 1 != 0 ||
                                index < 0 ||
                                index >= hourlyTimes.length) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                hourLabelAt(index),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            if (value % 1 != 0 ||
                                index < 0 ||
                                index >= hourlyPressure.length) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              hourlyPressure[index].round().toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: <LineChartBarData>[
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter:
                              (
                                FlSpot spot,
                                double xPercentage,
                                LineChartBarData bar,
                                int index,
                              ) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: Colors.blue,
                                  strokeWidth: 0,
                                );
                              },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withValues(alpha: 0.16),
                        ),
                      ),
                    ],
                    minX: -0.5,
                    maxX: (hourlyPressure.length - 1).toDouble() + 0.5,
                    minY: minY,
                    maxY: maxY,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

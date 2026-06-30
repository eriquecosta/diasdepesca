import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weather_store.dart';
import 'widgets/weather_charts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late final WeatherStore store;
  late final TabController _tabController;

  Widget _buildTabIcon(String assetPath, Color color) {
    return SvgPicture.asset(
      assetPath,
      width: 32,
      height: 32,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  @override
  void initState() {
    super.initState();
    store = Modular.get<WeatherStore>();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.loadWeather();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: Observer(
        builder: (_) {
          if (store.isLoading && !store.hasWeather) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!store.hasWeather) {
            return Center(
              child: Text(
                store.errorMessage ?? 'Nenhum dado de clima disponível.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final textTheme = Theme.of(context).textTheme;
          final primaryColor = Theme.of(context).colorScheme.primary;
          final units = store.weather!.currentUnits;

          return Column(
            children: [
              // Seção de Condições Atuais
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Condições Atuais', style: textTheme.titleLarge),
                    const SizedBox(height: 24),
                    _CurrentWeatherItem(
                      label: 'Temperatura',
                      value: store.currentTemperature,
                      unit: units.temperature2m,
                    ),
                    const SizedBox(height: 16),
                    _CurrentWeatherItem(
                      label: 'Chuva',
                      value: store.currentPrecipitation,
                      unit: units.precipitation,
                    ),
                    const SizedBox(height: 16),
                    _CurrentWeatherItem(
                      label: 'Probabilidade de Chuva',
                      value: store.currentPrecipitationProbability,
                      unit: units.precipitationProbability,
                    ),
                    const SizedBox(height: 16),
                    _CurrentWeatherItem(
                      label: 'Vento',
                      value: store.currentWindSpeed,
                      unit: units.windSpeed10m,
                    ),
                    const SizedBox(height: 16),
                    _CurrentWeatherItem(
                      label: 'Pressão Atmosférica',
                      value: store.currentPressureMsl,
                      unit: units.pressureMsl,
                    ),
                  ],
                ),
              ),
              // Abas com Detalhes
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: primaryColor,
                        labelColor: primaryColor,
                        unselectedLabelColor: primaryColor.withValues(
                          alpha: 0.6,
                        ),
                        tabs: [
                          Tab(
                            icon: _buildTabIcon(
                              'assets/ic_temp.svg',
                              primaryColor,
                            ),
                          ),
                          Tab(
                            icon: _buildTabIcon(
                              'assets/ic_chuva.svg',
                              primaryColor,
                            ),
                          ),
                          Tab(
                            icon: _buildTabIcon(
                              'assets/ic_vento.svg',
                              primaryColor,
                            ),
                          ),
                          Tab(
                            icon: _buildTabIcon(
                              'assets/ic_barometro.svg',
                              primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 280,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Temperatura - Gráfico de linha
                            TemperatureChart(
                              temperatures: store.hourlyTemperatures,
                              times: store.hourlyTimes,
                              unit: units.temperature2m,
                            ),
                            // Precipitação - Gráfico de barras
                            PrecipitationChart(
                              precipitation: store.hourlyPrecipitation,
                              probability: store.hourlyPrecipitationProbability,
                              times: store.hourlyTimes,
                              precipitationUnit: units.precipitation,
                              probabilityUnit: units.precipitationProbability,
                            ),
                            // Vento - Gráfico de barras
                            WindChart(
                              windSpeeds: store.hourlyWindSpeed,
                              windGusts: store.hourlyWindGusts,
                              windDirections: store.hourlyWindDirection,
                              times: store.hourlyTimes,
                              unit: units.windSpeed10m,
                              gustUnit:
                                  store.weather?.hourlyUnits?.windGusts10m,
                            ),
                            // Pressão - Gráfico de linha
                            PressureChart(
                              pressures: store.hourlyPressure,
                              times: store.hourlyTimes,
                              unit: units.pressureMsl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Widget que exibe um item de informação atual (label, valor e unidade)
class _CurrentWeatherItem extends StatelessWidget {
  final String label;
  final double? value;
  final String unit;

  const _CurrentWeatherItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium),
        Text(
          value != null ? '${value!.toStringAsFixed(1)} $unit' : 'N/A',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

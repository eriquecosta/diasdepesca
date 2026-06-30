import 'package:mobx/mobx.dart';

import '../../../core/local/models/weather_local_model.dart';
import '../../../core/services/interfaces/location_interface.dart';
import '../../../core/services/interfaces/weather_interface.dart';
import '../../../core/services/models/weather_model.dart';

part 'weather_store.g.dart';

// ignore: library_private_types_in_public_api
class WeatherStore = _WeatherStoreBase with _$WeatherStore;

abstract class _WeatherStoreBase with Store {
  _WeatherStoreBase({
    required IWeather repository,
    required ILocation locationService,
  }) : _repository = repository,
       _locationService = locationService;

  final IWeather _repository;
  final ILocation _locationService;

  @observable
  WeatherModel? weather;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  double? latitude;

  @observable
  double? longitude;

  @computed
  double? get currentTemperature => weather?.current.temperature2m;

  @computed
  double? get currentPrecipitation => weather?.current.precipitation;

  @computed
  double? get currentPrecipitationProbability =>
      weather?.current.precipitationProbability;

  @computed
  double? get currentWindSpeed => weather?.current.windSpeed10m;

  @computed
  double? get currentWindDirection => weather?.current.windDirection10m;

  @computed
  double? get currentPressureMsl => weather?.current.pressureMsl;

  @computed
  bool get hasWeather => weather != null;

  @computed
  bool get hasLocation => latitude != null && longitude != null;

  @computed
  List<double> get hourlyTemperatures => weather?.hourly?.temperature2m ?? [];

  @computed
  List<double> get hourlyPrecipitation => weather?.hourly?.precipitation ?? [];

  @computed
  List<double> get hourlyPrecipitationProbability =>
      weather?.hourly?.precipitationProbability ?? [];

  @computed
  List<double> get hourlyWindSpeed => weather?.hourly?.windSpeed10m ?? [];

  @computed
  List<double> get hourlyWindGusts => weather?.hourly?.windGusts10m ?? [];

  @computed
  List<double> get hourlyWindDirection =>
      weather?.hourly?.windDirection10m ?? [];

  @computed
  List<double> get hourlyPressure => weather?.hourly?.pressureMsl ?? [];

  @computed
  List<String> get hourlyTimes => weather?.hourly?.time ?? [];

  @action
  Future<void> loadWeather() async {
    isLoading = true;
    errorMessage = null;

    try {
      // Obter localização antes de fazer o fetch
      if (!hasLocation) {
        await _fetchLocation();
      }

      if (!hasLocation) {
        errorMessage =
            'Nao foi possivel obter sua localizacao. Ative o GPS e tente novamente.';
        return;
      }

      // Obter registro local e verificar se é de hoje
      WeatherLocalModel? lastLocal;
      bool hasRecordForToday = false;

      try {
        lastLocal = await _repository.get();
        if (lastLocal != null) {
          hasRecordForToday = !_shouldFetchForToday(lastLocal.cachedAt);
          // Se temos registro de hoje, usar como inicial enquanto faz fetch
          if (hasRecordForToday) {
            weather = lastLocal.toWeatherModel();
          }
        }
      } on StateError {
        weather = null;
      }

      // Fazer fetch: com hourly=true se é registro novo, false se é atualização de hoje
      final bool fetched = await _repository.fetch(
        latitude!,
        longitude!,
        // true,
        !hasRecordForToday,
      );
      if (fetched) {
        final lastLocal = await _repository.get();
        if (lastLocal != null) {
          weather = lastLocal.toWeatherModel();
        }
        return;
      }

      if (weather == null) {
        errorMessage = 'Nao foi possivel carregar os dados do clima.';
      }
    } catch (e) {
      if (weather == null) {
        errorMessage = e.toString();
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _fetchLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      errorMessage = 'Erro ao obter localizacao: $e';
      rethrow;
    }
  }

  bool _shouldFetchForToday(DateTime cachedAt) {
    final DateTime today = DateTime.now();
    final DateTime cachedDate = DateTime(
      cachedAt.year,
      cachedAt.month,
      cachedAt.day,
    );
    final DateTime todayDate = DateTime(today.year, today.month, today.day);
    return cachedDate.isBefore(todayDate);
  }
}

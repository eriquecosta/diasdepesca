import '../../local/models/weather_local_model.dart';

abstract class IWeather {
  Future<bool> fetch(double latitude, double longitude, [bool hourly]);
  Future<WeatherLocalModel?> get();
}

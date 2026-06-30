import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../local/models/weather_local_model.dart';
import '../../local/repositories/weather_local_repository.dart';
import '../interfaces/weather_interface.dart';
import '../models/weather_model.dart';

class WeatherRepository implements IWeather {
  WeatherRepository({
    WeatherLocalDataSource? localRepository,
    Future<http.Response> Function(Uri uri)? httpGet,
  }) : _localRepository = localRepository ?? WeatherLocalRepository(),
       _httpGet = httpGet ?? http.get;

  final WeatherLocalDataSource _localRepository;
  final Future<http.Response> Function(Uri uri) _httpGet;

  @override
  Future<bool> fetch(
    double latitude,
    double longitude, [
    bool hourly = false,
  ]) async {
    final Map<String, String> queryParams = <String, String>{
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'precipitation_probability,temperature_2m,precipitation,wind_speed_10m,pressure_msl,wind_direction_10m',
      if (hourly)
        'hourly':
            'temperature_2m,wind_speed_10m,wind_gusts_10m,pressure_msl,precipitation,precipitation_probability,wind_direction_10m',
      // 'elevation': 'nan',
    };

    final Uri uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      queryParams,
    );
    // print(uri);
    try {
      final http.Response response = await _httpGet(uri);
      if (response.statusCode != 200) {
        return false;
      }
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final WeatherModel weather = WeatherModel.fromJson(decoded);
      final WeatherModel weatherToSave = await _mergeHourlyIfMissing(weather);
      await _localRepository.saveOrUpdateToday(weatherToSave);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<WeatherModel> _mergeHourlyIfMissing(WeatherModel incoming) async {
    if (incoming.hourly != null && incoming.hourlyUnits != null) {
      return incoming;
    }

    final WeatherLocalModel? latestRecord = await _localRepository
        .getLatestRecord();
    if (latestRecord == null) {
      return incoming;
    }

    final WeatherModel cachedWeather = latestRecord.toWeatherModel();

    return WeatherModel(
      latitude: incoming.latitude,
      longitude: incoming.longitude,
      generationtimeMs: incoming.generationtimeMs,
      utcOffsetSeconds: incoming.utcOffsetSeconds,
      timezone: incoming.timezone,
      timezoneAbbreviation: incoming.timezoneAbbreviation,
      elevation: incoming.elevation,
      currentUnits: incoming.currentUnits,
      current: incoming.current,
      hourlyUnits: incoming.hourlyUnits ?? cachedWeather.hourlyUnits,
      hourly: incoming.hourly ?? cachedWeather.hourly,
    );
  }

  @override
  Future<WeatherLocalModel?> get() async {
    return await _localRepository.getLatestRecord();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../local/models/weather_local_model.dart';
import '../../local/repositories/weather_local_repository.dart';
import '../interfaces/service_interface.dart';
import '../models/weather_model.dart';

class WeatherRepository implements ServiceInterface<WeatherModel> {
  WeatherRepository({
    WeatherLocalDataSource? localRepository,
    Future<http.Response> Function(Uri uri)? httpGet,
    DateTime Function()? now,
  }) : _localRepository = localRepository ?? WeatherLocalRepository(),
       _httpGet = httpGet ?? http.get,
       _now = now ?? DateTime.now;

  final WeatherLocalDataSource _localRepository;
  final Future<http.Response> Function(Uri uri) _httpGet;
  final DateTime Function() _now;

  @override
  Future<bool> fetch() async {
    final WeatherLocalModel? localRecord =
        await _localRepository.getLatestRecord();
    if (localRecord != null && !_shouldFetchForToday(localRecord.cachedAt)) {
      return true;
    }

    final Map<String, String> queryParams = <String, String>{
      'latitude': '-16.078529',
      'longitude': '-47.980858',
      'current':
          'precipitation_probability,temperature_2m,precipitation,wind_speed_10m,surface_pressure',
      'hourly':
          'temperature_2m,wind_speed_10m,surface_pressure,precipitation,precipitation_probability',
      'elevation': 'nan',
    };

    final Uri uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      queryParams,
    );

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
      await _localRepository.save(weather);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<WeatherModel> get() async {
    final WeatherModel? weather = await _localRepository.getLatest();
    if (weather == null) {
      throw StateError(
        'Nenhum dado local encontrado. Execute fetch() antes de get().',
      );
    }

    return weather;
  }

  bool _shouldFetchForToday(DateTime cachedAt) {
    final DateTime today = _now();
    final DateTime cachedDate = DateTime(
      cachedAt.year,
      cachedAt.month,
      cachedAt.day,
    );
    final DateTime todayDate = DateTime(today.year, today.month, today.day);
    return cachedDate.isBefore(todayDate);
  }
}

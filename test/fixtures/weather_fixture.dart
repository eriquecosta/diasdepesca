import 'package:dias_de_pesca/core/services/models/weather_model.dart';

Map<String, dynamic> weatherJsonFixture() {
  return <String, dynamic>{
    'latitude': -16.06,
    'longitude': -47.98,
    'generationtime_ms': 0.25,
    'utc_offset_seconds': 0,
    'timezone': 'GMT',
    'timezone_abbreviation': 'GMT',
    'elevation': 1056.0,
    'current_units': <String, dynamic>{
      'time': 'iso8601',
      'interval': 'seconds',
      'precipitation_probability': '%',
      'temperature_2m': '°C',
      'precipitation': 'mm',
      'wind_speed_10m': 'km/h',
      'wind_direction_10m': '°',
      'pressure_msl': 'hPa',
    },
    'current': <String, dynamic>{
      'time': '2026-06-16T00:00',
      'interval': 900,
      'precipitation_probability': 20,
      'temperature_2m': 21.0,
      'precipitation': 0.0,
      'wind_speed_10m': 2.2,
      'wind_direction_10m': 157.0,
      'pressure_msl': 901.5,
    },
    'hourly_units': <String, dynamic>{
      'time': 'iso8601',
      'temperature_2m': '°C',
      'wind_speed_10m': 'km/h',
      'wind_gusts_10m': 'km/h',
      'wind_direction_10m': '°',
      'pressure_msl': 'hPa',
      'precipitation': 'mm',
      'precipitation_probability': '%',
    },
    'hourly': <String, dynamic>{
      'time': <String>['2026-06-16T00:00', '2026-06-16T01:00'],
      'temperature_2m': <double>[21.0, 20.7],
      'wind_speed_10m': <double>[2.2, 3.5],
      'wind_gusts_10m': <double>[5.0, 6.3],
      'wind_direction_10m': <double>[157.0, 162.0],
      'pressure_msl': <double>[901.5, 901.6],
      'precipitation': <double>[0.0, 0.0],
      'precipitation_probability': <double>[20.0, 12.0],
    },
  };
}

WeatherModel weatherModelFixture() {
  return WeatherModel.fromJson(weatherJsonFixture());
}

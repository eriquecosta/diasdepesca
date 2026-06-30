// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
  utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
  timezone: json['timezone'] as String,
  timezoneAbbreviation: json['timezone_abbreviation'] as String,
  elevation: (json['elevation'] as num).toDouble(),
  currentUnits: WeatherCurrentUnits.fromJson(
    json['current_units'] as Map<String, dynamic>,
  ),
  current: WeatherCurrent.fromJson(json['current'] as Map<String, dynamic>),
  hourlyUnits: json['hourly_units'] == null
      ? null
      : WeatherHourlyUnits.fromJson(
          json['hourly_units'] as Map<String, dynamic>,
        ),
  hourly: json['hourly'] == null
      ? null
      : WeatherHourly.fromJson(json['hourly'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'generationtime_ms': instance.generationtimeMs,
      'utc_offset_seconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'timezone_abbreviation': instance.timezoneAbbreviation,
      'elevation': instance.elevation,
      'current_units': instance.currentUnits,
      'current': instance.current,
      'hourly_units': instance.hourlyUnits,
      'hourly': instance.hourly,
    };

WeatherCurrentUnits _$WeatherCurrentUnitsFromJson(Map<String, dynamic> json) =>
    WeatherCurrentUnits(
      time: json['time'] as String,
      interval: json['interval'] as String,
      precipitationProbability: json['precipitation_probability'] as String,
      temperature2m: json['temperature_2m'] as String,
      precipitation: json['precipitation'] as String,
      windSpeed10m: json['wind_speed_10m'] as String,
      windDirection10m: json['wind_direction_10m'] as String?,
      pressureMsl: json['pressure_msl'] as String,
    );

Map<String, dynamic> _$WeatherCurrentUnitsToJson(
  WeatherCurrentUnits instance,
) => <String, dynamic>{
  'time': instance.time,
  'interval': instance.interval,
  'precipitation_probability': instance.precipitationProbability,
  'temperature_2m': instance.temperature2m,
  'precipitation': instance.precipitation,
  'wind_speed_10m': instance.windSpeed10m,
  'wind_direction_10m': instance.windDirection10m,
  'pressure_msl': instance.pressureMsl,
};

WeatherCurrent _$WeatherCurrentFromJson(Map<String, dynamic> json) =>
    WeatherCurrent(
      time: json['time'] as String,
      interval: (json['interval'] as num).toInt(),
      precipitationProbability: (json['precipitation_probability'] as num)
          .toDouble(),
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
      windDirection10m: (json['wind_direction_10m'] as num?)?.toDouble(),
      pressureMsl: (json['pressure_msl'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherCurrentToJson(WeatherCurrent instance) =>
    <String, dynamic>{
      'time': instance.time,
      'interval': instance.interval,
      'precipitation_probability': instance.precipitationProbability,
      'temperature_2m': instance.temperature2m,
      'precipitation': instance.precipitation,
      'wind_speed_10m': instance.windSpeed10m,
      'wind_direction_10m': instance.windDirection10m,
      'pressure_msl': instance.pressureMsl,
    };

WeatherHourlyUnits _$WeatherHourlyUnitsFromJson(Map<String, dynamic> json) =>
    WeatherHourlyUnits(
      time: json['time'] as String,
      temperature2m: json['temperature_2m'] as String,
      windSpeed10m: json['wind_speed_10m'] as String,
      windGusts10m: json['wind_gusts_10m'] as String?,
      windDirection10m: json['wind_direction_10m'] as String?,
      pressureMsl: json['pressure_msl'] as String,
      precipitation: json['precipitation'] as String,
      precipitationProbability: json['precipitation_probability'] as String,
    );

Map<String, dynamic> _$WeatherHourlyUnitsToJson(WeatherHourlyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature2m,
      'wind_speed_10m': instance.windSpeed10m,
      'wind_gusts_10m': instance.windGusts10m,
      'wind_direction_10m': instance.windDirection10m,
      'pressure_msl': instance.pressureMsl,
      'precipitation': instance.precipitation,
      'precipitation_probability': instance.precipitationProbability,
    };

WeatherHourly _$WeatherHourlyFromJson(Map<String, dynamic> json) =>
    WeatherHourly(
      time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      temperature2m: (json['temperature_2m'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      windSpeed10m: (json['wind_speed_10m'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      windGusts10m: (json['wind_gusts_10m'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      windDirection10m: (json['wind_direction_10m'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      pressureMsl: (json['pressure_msl'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      precipitation: (json['precipitation'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      precipitationProbability:
          (json['precipitation_probability'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
    );

Map<String, dynamic> _$WeatherHourlyToJson(WeatherHourly instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature2m,
      'wind_speed_10m': instance.windSpeed10m,
      'wind_gusts_10m': instance.windGusts10m,
      'wind_direction_10m': instance.windDirection10m,
      'pressure_msl': instance.pressureMsl,
      'precipitation': instance.precipitation,
      'precipitation_probability': instance.precipitationProbability,
    };

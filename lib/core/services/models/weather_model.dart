import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final double latitude;
  final double longitude;
  @JsonKey(name: 'generationtime_ms')
  final double generationtimeMs;
  @JsonKey(name: 'utc_offset_seconds')
  final int utcOffsetSeconds;
  final String timezone;
  @JsonKey(name: 'timezone_abbreviation')
  final String timezoneAbbreviation;
  final double elevation;
  @JsonKey(name: 'current_units')
  final WeatherCurrentUnits currentUnits;
  final WeatherCurrent current;
  @JsonKey(name: 'hourly_units')
  final WeatherHourlyUnits hourlyUnits;
  final WeatherHourly hourly;

  const WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.currentUnits,
    required this.current,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@JsonSerializable()
class WeatherCurrentUnits {
  final String time;
  final String interval;
  @JsonKey(name: 'precipitation_probability')
  final String precipitationProbability;
  @JsonKey(name: 'temperature_2m')
  final String temperature2m;
  final String precipitation;
  @JsonKey(name: 'wind_speed_10m')
  final String windSpeed10m;
  @JsonKey(name: 'surface_pressure')
  final String surfacePressure;

  const WeatherCurrentUnits({
    required this.time,
    required this.interval,
    required this.precipitationProbability,
    required this.temperature2m,
    required this.precipitation,
    required this.windSpeed10m,
    required this.surfacePressure,
  });

  factory WeatherCurrentUnits.fromJson(Map<String, dynamic> json) =>
      _$WeatherCurrentUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherCurrentUnitsToJson(this);
}

@JsonSerializable()
class WeatherCurrent {
  final String time;
  final int interval;
  @JsonKey(name: 'precipitation_probability')
  final double precipitationProbability;
  @JsonKey(name: 'temperature_2m')
  final double temperature2m;
  final double precipitation;
  @JsonKey(name: 'wind_speed_10m')
  final double windSpeed10m;
  @JsonKey(name: 'surface_pressure')
  final double surfacePressure;

  const WeatherCurrent({
    required this.time,
    required this.interval,
    required this.precipitationProbability,
    required this.temperature2m,
    required this.precipitation,
    required this.windSpeed10m,
    required this.surfacePressure,
  });

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) =>
      _$WeatherCurrentFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherCurrentToJson(this);
}

@JsonSerializable()
class WeatherHourlyUnits {
  final String time;
  @JsonKey(name: 'temperature_2m')
  final String temperature2m;
  @JsonKey(name: 'wind_speed_10m')
  final String windSpeed10m;
  @JsonKey(name: 'surface_pressure')
  final String surfacePressure;
  final String precipitation;
  @JsonKey(name: 'precipitation_probability')
  final String precipitationProbability;

  const WeatherHourlyUnits({
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.surfacePressure,
    required this.precipitation,
    required this.precipitationProbability,
  });

  factory WeatherHourlyUnits.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherHourlyUnitsToJson(this);
}

@JsonSerializable()
class WeatherHourly {
  final List<String> time;
  @JsonKey(name: 'temperature_2m')
  final List<double> temperature2m;
  @JsonKey(name: 'wind_speed_10m')
  final List<double> windSpeed10m;
  @JsonKey(name: 'surface_pressure')
  final List<double> surfacePressure;
  final List<double> precipitation;
  @JsonKey(name: 'precipitation_probability')
  final List<double> precipitationProbability;

  const WeatherHourly({
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.surfacePressure,
    required this.precipitation,
    required this.precipitationProbability,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherHourlyToJson(this);
}

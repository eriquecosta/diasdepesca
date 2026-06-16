import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../services/models/weather_model.dart';

@Entity()
class WeatherLocalModel {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime cachedAt;

  String payloadJson;

  WeatherLocalModel({
    this.id = 0,
    required this.cachedAt,
    required this.payloadJson,
  });

  factory WeatherLocalModel.fromWeatherModel(
    WeatherModel weather, {
    int id = 0,
    DateTime? cachedAt,
  }) {
    return WeatherLocalModel(
      id: id,
      cachedAt: cachedAt ?? DateTime.now(),
      payloadJson: jsonEncode(weather.toJson()),
    );
  }

  WeatherModel toWeatherModel() {
    final dynamic decoded = jsonDecode(payloadJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('payloadJson invalido para WeatherModel');
    }

    return WeatherModel.fromJson(decoded);
  }
}

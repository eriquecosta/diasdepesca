import 'package:objectbox/objectbox.dart';

import '../../services/models/weather_model.dart';
import '../models/weather_local_model.dart';
import '../objectbox/objectbox_database.dart';

abstract class WeatherLocalDataSource {
  Future<int> save(WeatherModel weather);
  Future<WeatherLocalModel?> getLatestRecord();
  Future<WeatherModel?> getLatest();
}

class WeatherLocalRepository implements WeatherLocalDataSource {
  WeatherLocalRepository({Box<WeatherLocalModel>? box})
    : _box = box ?? ObjectBoxDatabase.weatherBox;

  final Box<WeatherLocalModel> _box;

  @override
  Future<int> save(WeatherModel weather) async {
    final WeatherLocalModel local = WeatherLocalModel.fromWeatherModel(weather);
    return _box.put(local);
  }

  @override
  Future<WeatherLocalModel?> getLatestRecord() async {
    final List<WeatherLocalModel> all = _box.getAll();
    if (all.isEmpty) {
      return null;
    }

    all.sort((WeatherLocalModel a, WeatherLocalModel b) {
      return b.cachedAt.compareTo(a.cachedAt);
    });

    return all.first;
  }

  @override
  Future<WeatherModel?> getLatest() async {
    final WeatherLocalModel? latest = await getLatestRecord();
    return latest?.toWeatherModel();
  }
}

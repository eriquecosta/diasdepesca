import 'package:objectbox/objectbox.dart';

import '../../services/models/weather_model.dart';
import '../models/weather_local_model.dart';
import '../objectbox/objectbox_database.dart';

abstract class WeatherLocalDataSource {
  Future<int> save(WeatherModel weather);
  Future<int> saveOrUpdateToday(WeatherModel weather);
  Future<WeatherLocalModel?> getLatestRecord();
  Future<WeatherLocalModel?> getRecordForToday();
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
  Future<int> saveOrUpdateToday(WeatherModel weather) async {
    final WeatherLocalModel? todayRecord = await getRecordForToday();

    if (todayRecord != null) {
      // Atualizar registro existente, mantendo o ID
      final WeatherLocalModel updated = WeatherLocalModel.fromWeatherModel(
        weather,
        id: todayRecord.id,
        cachedAt: DateTime.now(),
      );
      return _box.put(updated);
    } else {
      // Criar novo registro
      final WeatherLocalModel local = WeatherLocalModel.fromWeatherModel(
        weather,
      );
      return _box.put(local);
    }
  }

  @override
  Future<WeatherLocalModel?> getRecordForToday() async {
    final List<WeatherLocalModel> all = _box.getAll();
    final DateTime today = DateTime.now();
    final DateTime todayDate = DateTime(today.year, today.month, today.day);

    for (final WeatherLocalModel record in all) {
      final DateTime recordDate = DateTime(
        record.cachedAt.year,
        record.cachedAt.month,
        record.cachedAt.day,
      );
      if (recordDate == todayDate) {
        return record;
      }
    }

    return null;
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

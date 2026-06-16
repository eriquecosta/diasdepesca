import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';
import '../models/weather_local_model.dart';

class ObjectBoxDatabase {
  ObjectBoxDatabase._();

  static Store? _store;

  static Future<void> init() async {
    if (_store != null) {
      return;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: '${appDocDir.path}/dias_de_pesca');
  }

  static Store get store {
    final Store? current = _store;
    if (current == null) {
      throw StateError('ObjectBoxDatabase nao inicializado. Chame init().');
    }

    return current;
  }

  static Box<WeatherLocalModel> get weatherBox =>
      store.box<WeatherLocalModel>();

  static Future<void> close() async {
    _store?.close();
    _store = null;
  }
}

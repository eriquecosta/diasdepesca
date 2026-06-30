import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../../../objectbox.g.dart';
import '../models/weather_local_model.dart';

class ObjectBoxDatabase {
  ObjectBoxDatabase._();

  static Store? _store;
  static Future<void>? _initializing;

  static Future<void> init() async {
    if (_store != null) {
      return;
    }

    final Future<void>? currentInit = _initializing;
    if (currentInit != null) {
      await currentInit;
      return;
    }

    final Future<void> initFuture = _initInternal();
    _initializing = initFuture;
    try {
      await initFuture;
    } finally {
      _initializing = null;
    }
  }

  static Future<void> _initInternal() async {
    final String directoryPath = (await defaultStoreDirectory()).path;

    if (Store.isOpen(directoryPath)) {
      _store = Store.attach(getObjectBoxModel(), directoryPath);
      return;
    }

    _store = await openStore(directory: directoryPath);
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
    final Future<void>? currentInit = _initializing;
    if (currentInit != null) {
      await currentInit;
    }
    _store?.close();
    _store = null;
  }
}

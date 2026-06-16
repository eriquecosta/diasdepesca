import 'package:mobx/mobx.dart';

part 'weather_store.g.dart';

// ignore: library_private_types_in_public_api
class WeatherStore = _WeatherStoreBase with _$WeatherStore;

abstract class _WeatherStoreBase with Store {
  // Adicione @observable e @action conforme necessidade
}

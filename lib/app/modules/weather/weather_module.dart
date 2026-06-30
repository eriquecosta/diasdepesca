import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/services/interfaces/location_interface.dart';
import '../../../core/services/interfaces/weather_interface.dart';
import '../../../core/services/repositories/location_service.dart';
import '../../../core/services/repositories/weather_repository.dart';
import 'weather_page.dart';
import 'weather_store.dart';

class WeatherModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<ILocation>(LocationService.new);
    i.addSingleton<IWeather>(WeatherRepository.new);
    i.addSingleton<WeatherStore>(
      () => WeatherStore(repository: i.get(), locationService: i.get()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const WeatherPage());
  }
}

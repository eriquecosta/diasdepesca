import 'package:flutter_modular/flutter_modular.dart';
import 'weather_page.dart';
import 'weather_store.dart';

class WeatherModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(WeatherStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const WeatherPage());
  }
}

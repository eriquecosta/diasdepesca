import 'package:flutter_modular/flutter_modular.dart';
import '../../routes.dart';
import '../calendar/calendar_module.dart';
import '../weather/weather_module.dart';
import 'home_page.dart';
import 'home_store.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(HomeStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      AppRoutes.home,
      child: (_) => const HomePage(),
      children: [
        ModuleRoute(AppRoutes.calendar, module: CalendarModule()),
        ModuleRoute(AppRoutes.weather, module: WeatherModule()),
      ],
    );
  }
}

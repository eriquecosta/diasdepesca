import 'package:flutter_modular/flutter_modular.dart';
import 'routes.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.module(AppRoutes.home, module: HomeModule());
  }
}

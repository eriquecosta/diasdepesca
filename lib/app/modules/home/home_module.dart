import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';
import 'home_store.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(HomeStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
  }
}

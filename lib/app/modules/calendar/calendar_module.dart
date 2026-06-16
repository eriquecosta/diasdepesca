import 'package:flutter_modular/flutter_modular.dart';
import 'calendar_page.dart';
import 'calendar_store.dart';

class CalendarModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(CalendarStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const CalendarPage());
  }
}

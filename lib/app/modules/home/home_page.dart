import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Modular.to.path == AppRoutes.home) {
        Modular.to.navigate(AppRoutes.calendar);
      }
    });
  }

  int _currentIndex() {
    if (Modular.to.path.startsWith(AppRoutes.weather)) {
      return 1;
    }
    return 0;
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      Modular.to.navigate(AppRoutes.calendar);
      return;
    }

    Modular.to.navigate(AppRoutes.weather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(),
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarDays),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cloudSun),
            label: 'Clima',
          ),
        ],
      ),
    );
  }
}

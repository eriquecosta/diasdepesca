import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'weather_store.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<WeatherStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('weather')),
      body: Observer(
        builder: (_) {
          store.hashCode;
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

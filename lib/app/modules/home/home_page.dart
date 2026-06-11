import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.get<HomeStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dias de Pesca')),
      body: Observer(
        builder:
            (_) => const Center(child: Text('Bem-vindo ao Dias de Pesca!')),
      ),
    );
  }
}

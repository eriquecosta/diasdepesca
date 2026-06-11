import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dias_de_pesca/core/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dias de Pesca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: Modular.routerConfig,
    );
  }
}

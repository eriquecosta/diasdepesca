import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'core/local/objectbox/objectbox_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxDatabase.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

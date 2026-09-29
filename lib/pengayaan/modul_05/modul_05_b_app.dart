import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'screens/sqlite_task_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  databaseFactory = databaseFactoryFfiWeb;

  runApp(const Modul05BApp());
}

class Modul05BApp extends StatelessWidget {
  const Modul05BApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 05 - Fase B',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0284C7),
        ),
        useMaterial3: true,
      ),
      home: const SqliteTaskScreen(),
    );
  }
}
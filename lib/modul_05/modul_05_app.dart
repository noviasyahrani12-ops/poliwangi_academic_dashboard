import 'package:flutter/material.dart';

import 'screens/task_list_screen.dart';

class Modul05App extends StatelessWidget {
  const Modul05App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 05 - Local Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
        ),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}
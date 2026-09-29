import 'package:flutter/material.dart';
import 'screens/tugas_mandiri_screen.dart';

void main() {
  runApp(const TugasMandiriApp());
}

class TugasMandiriApp extends StatelessWidget {
  const TugasMandiriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Mandiri Pertemuan 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const TugasMandiriScreen(),
    );
  }
}
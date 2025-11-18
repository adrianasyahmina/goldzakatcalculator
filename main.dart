// lib/main.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'about_page.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold Zakat Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
                primary: Colors.grey.shade800,
                secondary: Colors.amber.shade600
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
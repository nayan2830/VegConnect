// main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const VegConnectApp());
}

class VegConnectApp extends StatelessWidget {
  const VegConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VegConnect',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
      ),
      home: LoginScreen(),
    );
  }
}

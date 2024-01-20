import 'package:flutter/material.dart';
import 'package:reddit_clone/features/screens/login_screen.dart';
import 'package:reddit_clone/theme/pallete.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Clone',
      theme: Pallete.darkModeAppTheme,
      home: const LoginScreen(),
    );
  }
}

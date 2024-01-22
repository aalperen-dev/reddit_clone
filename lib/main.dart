import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/screens/login_screen.dart';
import 'package:reddit_clone/firebase_options.dart';
import 'package:reddit_clone/theme/pallete.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

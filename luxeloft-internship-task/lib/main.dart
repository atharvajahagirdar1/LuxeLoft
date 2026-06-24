import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LuxeLoftApp());
}

class LuxeLoftApp extends StatelessWidget {
  const LuxeLoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuxeLoft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF1497AD), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1497AD),
          primary: const Color(0xFF1497AD),
          secondary: const Color(0xFFF99D1C), 
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

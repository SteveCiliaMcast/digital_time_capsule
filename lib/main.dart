import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFFE3B6B1),
        scaffoldBackgroundColor: const Color(0xFFFFE3D8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE3B6B1),
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Digital Time Capsule")),
      body: const Center(child: Text("Map will be here")),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Home index
        context: context,
      ),
    );
  }
}

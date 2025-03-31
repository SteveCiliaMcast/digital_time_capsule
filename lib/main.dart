import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import the plugin
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart'; // Import the generated Firebase options
import 'bottom_nav_bar.dart';
import 'mainScreen/map_widget.dart';

// Initialize the notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the local notifications plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await _requestNotificationPermission();

  runApp(const MainApp());
}

Future<void> _requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
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
      body: const Column(
        children: [
          Expanded(
            child: MapWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Home index
        context: context,
      ),
    );
  }
}

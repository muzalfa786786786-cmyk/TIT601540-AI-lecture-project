import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_lecture.dart';
import 'screens/slides_screen.dart';
import 'screens/presentation_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Lecturer',

      // 🎨 App Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // 🚀 Starting Screen
      initialRoute: '/',

      // 📌 All Screens Routes
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/create': (context) => CreateLecture(),
        '/slides': (context) => SlidesScreen(),
        '/presentation': (context) => PresentationScreen(),
        '/chat': (context) => ChatScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}


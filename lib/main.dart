import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_lecture.dart';
import 'screens/slides_screen.dart';
import 'screens/presentation_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_posts_screen.dart';  // <-- New screen import
import 'screens/about_screen.dart';
import 'screens/gratitude_screen.dart';
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
      theme: ThemeData(
        primaryColor: Colors.red.shade700,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, primary: Colors.red.shade700),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.red.shade900,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const LoginScreen();
            break;
          case '/dashboard':
            page = const DashboardScreen();
            break;
        // Inside onGenerateRoute switch statement
          case '/about':
            page = const AboutScreen();
            break;
          case '/gratitude':
            page = const GratitudeScreen();
            break;
          case '/create':
            page = const CreateLecture();
            break;
          case '/slides':
            page = const SlidesScreen();
            break;
          case '/presentation':
            page = const PresentationScreen();
            break;
          case '/chat':
            page = const ChatScreen();
            break;
          case '/profile':
            page = const ProfileScreen();
            break;
          case '/profile_posts':          // <-- New route
            page = const ProfilePostsScreen();
            break;
          default:
            page = const LoginScreen();
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
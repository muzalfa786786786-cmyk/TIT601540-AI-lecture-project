import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Theme & Routes
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_nav.dart';
import 'screens/home_screen.dart';
import 'screens/slide_generator_screen.dart';
import 'screens/live_qa_screen.dart';
import 'screens/student_upload_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/saved_slides_screen.dart';
import 'screens/whiteboard_screen.dart';
import 'screens/avatar_screen.dart';
import 'screens/profile_screen.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/slides_provider.dart';
import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TeachLearnApp());
}

class TeachLearnApp extends StatelessWidget {
  const TeachLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SlidesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TeachLearn - AI Lecturer',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.auth: (_) => const AuthScreen(),
          AppRoutes.main: (_) => const MainNav(),
          // Removed 'const' here because (i) {} is a closure and cannot be constant.
          AppRoutes.home: (_) => HomeScreen(onNavigate: (i) {}),
          AppRoutes.aiSlides: (_) => const SlideGeneratorScreen(),
          AppRoutes.liveQA: (_) => const LiveQAScreen(),
          AppRoutes.upload: (_) => const StudentUploadScreen(),
          AppRoutes.courses: (_) => const CoursesScreen(),
          AppRoutes.saved: (_) => const SavedSlidesScreen(),
          AppRoutes.whiteboard: (_) => const WhiteboardScreen(),
          AppRoutes.avatar: (_) => const AvatarScreen(),
          AppRoutes.profile: (_) => const ProfileScreen(),
        },
      ),
    );
  }
}

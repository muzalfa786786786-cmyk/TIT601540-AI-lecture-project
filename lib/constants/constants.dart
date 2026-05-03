// lib/constants/constants.dart

class ApiConstants {
  // JSONPlaceholder API (for testing)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String usersEndpoint = '/users';
}

class FirebaseConstants {
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String coursesCollection = 'courses';
  static const String slidesCollection = 'slides';
  static const String messagesCollection = 'messages';
  static const String uploadsCollection = 'uploads';
}

class AppConstants {
  // App Info
  static const String appName = 'TeachLearn';
  static const String appVersion = '1.0.0';

  // SharedPreferences Keys
  static const String prefUserKey = 'user_data';
  static const String prefThemeKey = 'theme_mode';
  static const String prefNotificationsKey = 'notifications_enabled';

  // Default Values
  static const int defaultSlideCount = 10;
  static const int minSlideCount = 5;
  static const int maxSlideCount = 30;

  // AI Settings
  static const double aiTemperature = 0.7;
  static const int aiMaxTokens = 500;
}
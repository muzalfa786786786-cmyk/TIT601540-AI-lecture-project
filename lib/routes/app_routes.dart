// lib/routes/app_routes.dart

class AppRoutes {
  // ─── Auth & Main ──────────────────────────────────────────────
  static const String splash     = '/';
  static const String auth       = '/auth';
  static const String main       = '/main';

  // ─── Main Screens ─────────────────────────────────────────────
  static const String home       = '/home';
  static const String aiSlides   = '/ai-slides';
  static const String liveQA     = '/live-qa';
  static const String upload     = '/upload';
  static const String courses    = '/courses';
  static const String progress = '/progress';

  // ─── Secondary Screens ────────────────────────────────────────
  static const String saved      = '/saved-slides';
  static const String whiteboard = '/whiteboard';
  static const String avatar     = '/avatar';
  static const String profile    = '/profile';

  // ─── Additional Routes (Optional) ────────────────────────────
  static const String courseDetails = '/course-details';
  static const String presentation  = '/presentation';
  static const String settings      = '/settings';
  static const String about         = '/about';
  static const String help          = '/help';
}
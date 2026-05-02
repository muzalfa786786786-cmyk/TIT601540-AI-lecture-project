import 'dart:math';
// import 'package:google_generative_ai/google_generative_ai.dart';  // ✅ Comment out for now
import '../models/models.dart';

class ApiService {
  static final Random _rand = Random();

  // ⚠️ Replace this with your actual API key from https://aistudio.google.com/
  static const String _apiKey = 'AIzaSyCIuj7NIXV3l3oTPOVqnftriZNr3sAPZ3Q';  // ✅ Changed to placeholder

  // ─── Real AI Slide Generation (Gemini) ─────────────────────────
  static Future<List<String>> generateSlides({
    required String topic,
    required String subject,
    required String level,
    required int count,
  }) async {
    // Fallback to mock since actual API requires package
    await Future.delayed(const Duration(milliseconds: 2000));

    final List<String> slideTitles = [];
    final topics = [
      'Introduction to $topic',
      'Key Concepts of $topic',
      'Understanding the Fundamentals',
      'Practical Applications',
      'Advanced Topics in $topic',
      'Case Studies and Examples',
      'Common Challenges and Solutions',
      'Summary and Review',
      'Quiz and Assessment',
      'Further Resources'
    ];

    for (int i = 0; i < count && i < topics.length; i++) {
      slideTitles.add(topics[i]);
    }

    return slideTitles;
  }

  // ─── Real AI Q&A Response (Gemini) ─────────────────────────────
  static Future<String> getAIResponse(String question) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return _getSimulatedResponse(question);
  }

  static String _getSimulatedResponse(String userMessage) {
    final lowerMsg = userMessage.toLowerCase();

    if (lowerMsg.contains('hello') || lowerMsg.contains('hi')) {
      return "Hello! 👋 How can I assist you with your learning today?";
    } else if (lowerMsg.contains('help')) {
      return "I can help you with:\n\n📚 Understanding concepts\n💻 Code debugging\n📝 Project guidance\n🎓 Exam preparation\n\nWhat specific topic would you like help with?";
    } else if (lowerMsg.contains('flutter')) {
      return "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. It uses Dart programming language.\n\nWould you like to learn more about Flutter widgets or state management?";
    } else if (lowerMsg.contains('python')) {
      return "Python is a versatile programming language known for its simplicity and readability. It's widely used in data science, web development, and automation.\n\nWhat specific aspect of Python would you like to explore?";
    } else if (lowerMsg.contains('thank')) {
      return "You're very welcome! 😊 I'm glad I could help. Feel free to ask if you have more questions!";
    } else if (lowerMsg.contains('project') || lowerMsg.contains('fyp')) {
      return "Great! Working on a project is an excellent way to learn. Tell me about your project:\n\n• What is your project domain?\n• What technologies are you using?\n• What specific help do you need?\n\nI'll provide detailed guidance!";
    } else {
      return "That's an interesting question about '$userMessage'. Let me help you understand this better.\n\nCould you provide more details so I can give you a more accurate and helpful response?";
    }
  }

  // ─── Mock Data Methods (Restored for UI consistency) ───────────
  static List<CourseModel> getMockCourses() {
    return [
      CourseModel(id: '1', name: 'Mathematics', subject: 'Calculus', instructor: 'Dr. Ahmed', progress: 0.65, totalLectures: 24, colorHex: '#DC2626', icon: '📐'),
      CourseModel(id: '2', name: 'Physics', subject: 'Mechanics', instructor: 'Prof. Raza', progress: 0.42, totalLectures: 18, colorHex: '#2563EB', icon: '⚛️'),
      CourseModel(id: '3', name: 'Computer Science', subject: 'Data Structures', instructor: 'Dr. Fatima', progress: 0.88, totalLectures: 32, colorHex: '#16A34A', icon: '💻'),
      CourseModel(id: '4', name: 'Chemistry', subject: 'Organic Chemistry', instructor: 'Ms. Nadia', progress: 0.30, totalLectures: 20, colorHex: '#9333EA', icon: '🧪'),
    ];
  }

  static Future<List<SlideModel>> getSavedSlides() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SlideModel(id: '1', title: 'Calculus Basics', topic: 'Calculus', subject: 'Mathematics', level: 'Undergraduate', slideCount: 12, slides: [], createdAt: DateTime.now()),
      SlideModel(id: '2', title: 'Newton\'s Laws', topic: 'Physics', subject: 'Mechanics', level: 'Undergraduate', slideCount: 8, slides: [], createdAt: DateTime.now().subtract(const Duration(days: 1))),
      SlideModel(id: '3', title: 'Sorting Algorithms', topic: 'Computer Science', subject: 'Data Structures', level: 'Undergraduate', slideCount: 15, slides: [], createdAt: DateTime.now().subtract(const Duration(days: 2))),
    ];
  }

  static Future<void> saveSlideToLocal(SlideModel slide) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Slide saved: ${slide.title}');
  }

  static Future<void> deleteSavedSlide(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Slide deleted: $id');
  }

  static Future<void> deleteAllSavedSlides() async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('All slides deleted');
  }

  static Future<void> updateSavedSlide(SlideModel slide) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Slide updated: ${slide.title}');
  }

  static List<UploadModel> getMockUploads() {
    return [
      UploadModel(id: '1', fileName: 'Physics_Chapter3.pptx', fileType: 'PPTX', fileSize: '2.4 MB', uploadedAt: DateTime.now(), status: 'ready'),
      UploadModel(id: '2', fileName: 'Math_Formulas.pdf', fileType: 'PDF', fileSize: '1.1 MB', uploadedAt: DateTime.now().subtract(const Duration(days: 1)), status: 'ready'),
    ];
  }
}
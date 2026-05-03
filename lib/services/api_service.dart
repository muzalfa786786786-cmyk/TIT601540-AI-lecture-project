// lib/services/api_service.dart

import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static final Random _rand = Random();

  // Gemini API Configuration
  static const String _apiKey = 'AIzaSyCIuj7NIXV3l3oTPOVqnftriZNr3sAPZ3Q';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Flag to use real API or mock
  static bool useRealAPI = false;  // Set to true when API key is working

  // ─── AI Slide Generation (Gemini) ─────────────────────────────
  static Future<List<String>> generateSlides({
    required String topic,
    required String subject,
    required String level,
    required int count,
  }) async {
    if (useRealAPI && _apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY_HERE') {
      try {
        return await _generateSlidesWithGemini(topic, subject, level, count);
      } catch (e) {
        print("Gemini API error: $e, falling back to mock");
        return _generateMockSlides(topic, count);
      }
    }
    return _generateMockSlides(topic, count);
  }

  static Future<List<String>> _generateSlidesWithGemini(
      String topic, String subject, String level, int count) async {
    final url = Uri.parse("$_baseUrl?key=$_apiKey");

    final prompt = "Generate $count slide titles for a $level level lecture on '$topic' in $subject. "
        "Return only the titles, one per line, without numbering.";

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "maxOutputTokens": 500,
      }
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String text = data['candidates'][0]['content']['parts'][0]['text'];
      return text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .take(count)
          .toList();
    } else {
      throw Exception('API request failed');
    }
  }

  static List<String> _generateMockSlides(String topic, int count) {
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

  // ─── AI Q&A Response (Gemini) ─────────────────────────────────
  static Future<String> getAIResponse(String question) async {
    if (useRealAPI && _apiKey.isNotEmpty && _apiKey != 'YOUR_API_KEY_HERE') {
      try {
        return await _getGeminiResponse(question);
      } catch (e) {
        print("Gemini API error: $e, falling back to mock");
        return _getSimulatedResponse(question);
      }
    }
    return _getSimulatedResponse(question);
  }

  static Future<String> _getGeminiResponse(String question) async {
    final url = Uri.parse("$_baseUrl?key=$_apiKey");

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": question}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "maxOutputTokens": 800,
      }
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('API request failed');
    }
  }

  static String _getSimulatedResponse(String userMessage) {
    final lowerMsg = userMessage.toLowerCase();

    if (lowerMsg.contains('hello') || lowerMsg.contains('hi')) {
      return "Hello! 👋 How can I assist you with your learning today?";
    } else if (lowerMsg.contains('help')) {
      return "I can help you with:\n\n📚 Understanding concepts\n💻 Code debugging\n📝 Project guidance\n🎓 Exam preparation\n\nWhat specific topic would you like help with?";
    } else if (lowerMsg.contains('flutter')) {
      return "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. It uses Dart programming language.\n\nWould you like to learn more about Flutter widgets or state management?";
    } else if (lowerMsg.contains('dart')) {
      return "Dart is a programming language optimized for building mobile, desktop, backend, and web applications. It's the language used by Flutter!\n\nKey features:\n• Sound null safety\n• Async/await support\n• AOT and JIT compilation";
    } else if (lowerMsg.contains('python')) {
      return "Python is a versatile programming language known for its simplicity and readability. It's widely used in data science, web development, and automation.\n\nWhat specific aspect of Python would you like to explore?";
    } else if (lowerMsg.contains('firebase')) {
      return "Firebase is a Backend-as-a-Service (BaaS) platform by Google. It provides:\n\n• Authentication\n• Cloud Firestore database\n• Cloud Storage\n• Cloud Functions\n• Analytics\n\nWould you like to learn about a specific Firebase service?";
    } else if (lowerMsg.contains('thank')) {
      return "You're very welcome! 😊 I'm glad I could help. Feel free to ask if you have more questions!";
    } else if (lowerMsg.contains('project') || lowerMsg.contains('fyp')) {
      return "Great! Working on a project is an excellent way to learn. Tell me about your project:\n\n• What is your project domain?\n• What technologies are you using?\n• What specific help do you need?\n\nI'll provide detailed guidance!";
    } else if (lowerMsg.contains('what is') || lowerMsg.contains('define')) {
      return "That's a great question! Let me explain:\n\n$userMessage is an important concept. To give you the best answer, could you provide more context about which aspect you're interested in?";
    } else if (lowerMsg.contains('how to') || lowerMsg.contains('how do i')) {
      return "Here's a step-by-step approach:\n\n1️⃣ First, understand the basics\n2️⃣ Practice with simple examples\n3️⃣ Apply to your use case\n4️⃣ Review and optimize\n\nWhich step would you like me to elaborate on?";
    } else {
      return "That's an interesting question about '$userMessage'. Let me help you understand this better.\n\nCould you provide more details so I can give you a more accurate and helpful response?";
    }
  }

  // ─── Mock Data Methods ────────────────────────────────────────
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

  // ─── JSONPlaceholder API (For Lab) ─────────────────────────────
  static Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json, json['id'].toString())).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}
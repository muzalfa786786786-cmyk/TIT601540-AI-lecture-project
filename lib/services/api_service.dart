// lib/services/api_service.dart
import 'dart:math';
import '../models/models.dart';

class ApiService {
  static final Random _rand = Random();

  // ─── Mock AI Slide Generation ──────────────────────────────────
  static Future<List<String>> generateSlides({
    required String topic,
    required String subject,
    required String level,
    required int count,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2500));
    final templates = [
      'Introduction to $topic',
      'Key Concepts',
      'Historical Background',
      'Practical Applications',
      'Summary & Review',
    ];
    return List.generate(count.clamp(1, 15), (i) => templates[i % templates.length]);
  }

  // ─── Mock AI Q&A Response ──────────────────────────────────────
  static Future<String> getAIResponse(String question) async {
    await Future.delayed(Duration(milliseconds: 1200 + _rand.nextInt(800)));
    return "This is a mock AI response to your question: \"$question\". In a real app, this would come from an LLM.";
  }

  // ─── Mock Course Data ──────────────────────────────────────────
  static List<CourseModel> getMockCourses() {
    return [
      CourseModel(id: '1', name: 'Mathematics', subject: 'Calculus', instructor: 'Dr. Ahmed', progress: 0.65, totalLectures: 24, colorHex: '#DC2626', icon: '📐'),
      CourseModel(id: '2', name: 'Physics', subject: 'Mechanics', instructor: 'Prof. Raza', progress: 0.42, totalLectures: 18, colorHex: '#2563EB', icon: '⚛️'),
    ];
  }

  // ─── Mock Saved Slides ─────────────────────────────────────────
  static Future<List<SlideModel>> getSavedSlides() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SlideModel(
        id: '1', 
        title: 'Calculus Basics', 
        topic: 'Calculus', 
        subject: 'Mathematics', 
        level: 'Undergraduate', 
        slideCount: 12, 
        slides: [], 
        createdAt: DateTime.now()
      ),
    ];
  }

  static Future<void> saveSlideToLocal(SlideModel slide) async => await Future.delayed(const Duration(milliseconds: 300));
  static Future<void> deleteSavedSlide(String id) async => await Future.delayed(const Duration(milliseconds: 300));
  static Future<void> deleteAllSavedSlides() async => await Future.delayed(const Duration(milliseconds: 300));
  static Future<void> updateSavedSlide(SlideModel slide) async => await Future.delayed(const Duration(milliseconds: 300));

  // ─── Mock Uploads ──────────────────────────────────────────────
  static List<UploadModel> getMockUploads() {
    return [
      UploadModel(id: '1', fileName: 'Physics.pdf', fileType: 'PDF', fileSize: '2.4 MB', uploadedAt: DateTime.now(), status: 'ready'),
    ];
  }
}

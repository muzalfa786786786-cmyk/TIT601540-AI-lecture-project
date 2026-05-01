// lib/providers/slides_provider.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class SlidesProvider extends ChangeNotifier {
  List<String> _generatedSlides = [];
  List<SlideModel> _savedSlides = [];
  bool _isGenerating = false;
  double _progress = 0.0;
  String? _error;

  List<String> get generatedSlides => _generatedSlides;
  List<SlideModel> get savedSlides => _savedSlides;
  bool get isGenerating => _isGenerating;
  double get progress => _progress;
  String? get error => _error;
  bool get hasSlides => _generatedSlides.isNotEmpty;

  SlidesProvider() {
    loadSavedSlides();
  }

  Future<void> loadSavedSlides() async {
    try {
      _savedSlides = await ApiService.getSavedSlides();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load saved slides';
      notifyListeners();
    }
  }

  Future<void> generateSlides({
    required String topic,
    required String subject,
    required String level,
    required int count,
  }) async {
    _isGenerating = true;
    _progress = 0.0;
    _error = null;
    _generatedSlides = [];
    notifyListeners();

    // Progress simulation
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _progress = i / 10;
      notifyListeners();
    }

    try {
      _generatedSlides = await ApiService.generateSlides(
        topic: topic,
        subject: subject,
        level: level,
        count: count,
      );
    } catch (e) {
      _error = 'Failed to generate slides.';
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<bool> saveSlide(String title, String content, int index) async {
    try {
      final newSlide = SlideModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        topic: 'AI Generated',
        subject: 'General',
        level: 'All',
        slideCount: index + 1,
        slides: [content],
        createdAt: DateTime.now(),
        content: content,
        thumbnailColor: Colors.red,
      );

      _savedSlides.insert(0, newSlide);
      await ApiService.saveSlideToLocal(newSlide);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to save slide';
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteSavedSlide(String id) async {
    _savedSlides.removeWhere((s) => s.id == id);
    await ApiService.deleteSavedSlide(id);
    notifyListeners();
  }

  Future<void> deleteAllSavedSlides() async {
    _savedSlides.clear();
    await ApiService.deleteAllSavedSlides();
    notifyListeners();
  }

  Future<void> updateSlide(String id, {String? title, String? content}) async {
    final index = _savedSlides.indexWhere((s) => s.id == id);
    if (index != -1) {
      if (title != null) _savedSlides[index].title = title;
      if (content != null) _savedSlides[index].content = content;
      await ApiService.updateSavedSlide(_savedSlides[index]);
      notifyListeners();
    }
  }

  void clearSlides() {
    _generatedSlides = [];
    _progress = 0.0;
    _error = null;
    notifyListeners();
  }
}

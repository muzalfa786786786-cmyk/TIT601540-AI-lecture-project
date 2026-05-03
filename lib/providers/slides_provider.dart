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
  int get savedSlidesCount => _savedSlides.length;

  SlidesProvider() {
    loadSavedSlides();
  }

  // ─── Load Saved Slides ────────────────────────────────────────
  Future<void> loadSavedSlides() async {
    try {
      _savedSlides = await ApiService.getSavedSlides();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load saved slides';
      notifyListeners();
    }
  }

  // ─── Generate Slides ─────────────────────────────────────────
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
      _error = 'Failed to generate slides. Please try again.';
      _generatedSlides = [];
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  // ─── Save Slide ───────────────────────────────────────────────
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
      _error = 'Failed to save slide: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── Save All Generated Slides ────────────────────────────────
  Future<int> saveAllSlides() async {
    int savedCount = 0;
    for (int i = 0; i < _generatedSlides.length; i++) {
      final success = await saveSlide(_generatedSlides[i], _generatedSlides[i], i);
      if (success) savedCount++;
    }
    return savedCount;
  }

  // ─── Delete Saved Slide ───────────────────────────────────────
  Future<void> deleteSavedSlide(String id) async {
    try {
      _savedSlides.removeWhere((s) => s.id == id);
      await ApiService.deleteSavedSlide(id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete slide';
      notifyListeners();
    }
  }

  // ─── Delete All Saved Slides ──────────────────────────────────
  Future<void> deleteAllSavedSlides() async {
    try {
      _savedSlides.clear();
      await ApiService.deleteAllSavedSlides();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete all slides';
      notifyListeners();
    }
  }

  // ─── Update Slide ─────────────────────────────────────────────
  Future<void> updateSlide(String id, {String? title, String? content}) async {
    try {
      final index = _savedSlides.indexWhere((s) => s.id == id);
      if (index != -1) {
        if (title != null) _savedSlides[index].title = title;
        if (content != null) _savedSlides[index].content = content;
        await ApiService.updateSavedSlide(_savedSlides[index]);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update slide';
      notifyListeners();
    }
  }

  // ─── Clear Generated Slides ───────────────────────────────────
  void clearSlides() {
    _generatedSlides = [];
    _progress = 0.0;
    _error = null;
    notifyListeners();
  }

  // ─── Clear Error ──────────────────────────────────────────────
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ─── Get Progress Message ─────────────────────────────────────
  String getProgressMessage() {
    if (_progress < 0.3) return 'Analyzing topic...';
    if (_progress < 0.6) return 'Generating content...';
    if (_progress < 0.9) return 'Adding visuals...';
    return 'Finalizing slides...';
  }
}
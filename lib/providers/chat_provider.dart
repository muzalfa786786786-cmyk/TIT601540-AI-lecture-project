// lib/providers/chat_provider.dart
// Provider for Q&A chat state management

import 'package:flutter/material.dart';
import '../models/models.dart';  // ✅ Updated import (since models.dart has all models)
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  bool _isTyping = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  ChatProvider() {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessageModel(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Hello! 👋 I\'m your AI Tutor. Ask me anything about your lecture topic and I\'ll explain it clearly. You can also ask me to solve problems step by step! 🎓',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  // ─── Send Message ─────────────────────────────────────────────
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessageModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isTyping = true;
    notifyListeners();

    try {
      final response = await ApiService.getAIResponse(text);
      _messages.add(ChatMessageModel(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessageModel(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Sorry, I couldn\'t process your question. Please check your internet connection and try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  // ─── Clear Chat ───────────────────────────────────────────────
  void clearChat() {
    _messages.clear();
    _addWelcomeMessage();
    notifyListeners();
  }

  // ─── Delete Single Message ────────────────────────────────────
  void deleteMessage(String id) {
    _messages.removeWhere((message) => message.id == id);
    notifyListeners();
  }

  // ─── Get Message Count ────────────────────────────────────────
  int get messageCount => _messages.length;
  int get userMessageCount => _messages.where((m) => m.isUser).length;
  int get aiMessageCount => _messages.where((m) => !m.isUser).length;

  // ─── Get Last Message ─────────────────────────────────────────
  ChatMessageModel? get lastMessage => _messages.isNotEmpty ? _messages.last : null;

  // ─── Check if chat has messages ───────────────────────────────
  bool get hasMessages => _messages.length > 1; // More than welcome message
}
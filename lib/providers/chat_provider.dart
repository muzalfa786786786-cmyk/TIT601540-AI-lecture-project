// lib/providers/chat_provider.dart
// Provider for Q&A chat state management

import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';  // ✅ Fixed import
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];  // ✅ Changed to ChatMessageModel
  bool _isTyping = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  ChatProvider() {
    // Welcome message
    _messages.add(ChatMessageModel(
      id: '0',
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isTyping = true;
    notifyListeners();

    try {
      final response = await ApiService.getAIResponse(text);
      _messages.add(ChatMessageModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessageModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_err',
        text: 'Sorry, I couldn\'t process your question. Please try again.',
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
    // Add welcome message back
    _messages.add(ChatMessageModel(
      id: '0',
      text: 'Hello! 👋 I\'m your AI Tutor. Ask me anything about your lecture topic and I\'ll explain it clearly. You can also ask me to solve problems step by step! 🎓',
      isUser: false,
      timestamp: DateTime.now(),
    ));
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
}

// ─── Message Model (if not exists separately) ───────────────────
// If you don't have chat_message_model.dart, use this:
/*
class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
*/
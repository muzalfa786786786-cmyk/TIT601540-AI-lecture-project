// lib/services/auth_service.dart
// Authentication service — Simplified for API Integration Lab
// Note: This is separate from the JSONPlaceholder API users

import '../models/user_model.dart';

class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ─── Get Current User ─────────────────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  // ─── Mock Login (For app authentication, not API users) ───────
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Demo user (separate from API users list)
    _currentUser = UserModel(
      id: 1, // ✅ Changed to int
      name: email.split('@').first,
      email: email,
      phone: '123-456-7890',
    );
    return _currentUser;
  }

  // ─── Mock Register ────────────────────────────────────────────
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('Please fill all fields correctly');
    }

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch, // ✅ Changed to int
      name: name,
      email: email,
      phone: '',
    );
    return _currentUser;
  }

  // ─── Update User Profile ──────────────────────────────────────
  Future<void> updateUserProfile({
    String? name,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
      );
    }
  }

  // ─── Logout ───────────────────────────────────────────────────
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  // ─── Reset Password ───────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty) throw Exception('Enter a valid email');
  }
}

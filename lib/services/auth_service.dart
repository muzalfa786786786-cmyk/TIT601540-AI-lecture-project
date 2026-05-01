// lib/services/auth_service.dart
// Authentication service — mock implementation
// Replace with Firebase Auth in production

import '../models/user_model.dart';  // ✅ Fixed import

class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ─── Get Current User ─────────────────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  // ─── Mock Login ───────────────────────────────────────────────
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock validation
    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid credentials');
    }

    _currentUser = UserModel(
      id: 'user_001',  // ✅ Changed from uid to id
      name: email.split('@').first,
      email: email,
      role: 'student',
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
    await Future.delayed(const Duration(milliseconds: 1400));

    if (email.isEmpty || password.length < 6 || name.isEmpty) {
      throw Exception('Please fill all fields correctly');
    }

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',  // ✅ Changed from uid to id
      name: name,
      email: email,
      role: role,
    );
    return _currentUser;
  }

  // ─── Update User Profile ──────────────────────────────────────
  Future<void> updateUserProfile({
    String? name,
    String? photoURL,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        photoURL: photoURL ?? _currentUser!.photoURL,
        createdAt: _currentUser!.createdAt,
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
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty) throw Exception('Enter a valid email');
  }
}

/*
 * ─── FIREBASE INTEGRATION GUIDE ───────────────────────────────
 * To use real Firebase Auth, replace the methods above with:
 *
 * import 'package:firebase_auth/firebase_auth.dart';
 * import 'package:cloud_firestore/cloud_firestore.dart';
 *
 * final FirebaseAuth _auth = FirebaseAuth.instance;
 * final FirebaseFirestore _db = FirebaseFirestore.instance;
 *
 * Future<UserModel?> login({...}) async {
 *   final cred = await _auth.signInWithEmailAndPassword(
 *     email: email, password: password);
 *   final doc = await _db.collection('users').doc(cred.user!.uid).get();
 *   return UserModel.fromJson(doc.data()!, doc.id);
 * }
 *
 * Also add google-services.json (Android) and
 * GoogleService-Info.plist (iOS) to your project.
 */
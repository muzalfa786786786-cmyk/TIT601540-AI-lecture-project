// lib/services/auth_service.dart
// Authentication service with Firebase

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';  // ✅ Fixed import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Get Current User ─────────────────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return await _getUserFromFirestore(user.uid);
    }
    return null;
  }

  // ─── Get User from Firestore ──────────────────────────────────
  Future<UserModel?> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return UserModel.fromFirestore(data, uid);
        }
      }
      return null;
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  // ─── Login with Email & Password ──────────────────────────────
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        return await _getUserFromFirestore(user.uid);
      }
      return null;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ─── Register with Email & Password ───────────────────────────
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);

        // Create user document in Firestore
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email.trim(),
          role: role,
          photoURL: null,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

        return userModel;
      }
      return null;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ─── Reset Password ───────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ─── Update User Profile ──────────────────────────────────────
  Future<void> updateUserProfile({
    String? name,
    String? photoURL,
  }) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      if (name != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      if (photoURL != null && photoURL.isNotEmpty) {
        await user.updatePhotoURL(photoURL);
      }

      // Update Firestore
      final Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (photoURL != null && photoURL.isNotEmpty) updateData['photoURL'] = photoURL;

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updateData);
      }
    }
  }

  // ─── Delete User Account ──────────────────────────────────────
  Future<void> deleteAccount() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Delete from Firestore first
      await _firestore.collection('users').doc(user.uid).delete();
      // Then delete from Auth
      await user.delete();
    }
  }

  // ─── Error Handler ────────────────────────────────────────────
  String _handleAuthError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'Email already in use. Please use another email.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return e.message ?? 'Authentication failed. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  // ─── Check if email is verified ───────────────────────────────
  Future<bool> isEmailVerified() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  // ─── Send Email Verification ──────────────────────────────────
  Future<void> sendEmailVerification() async {
    final User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
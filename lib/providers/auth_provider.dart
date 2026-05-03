// lib/providers/auth_provider.dart
// Provider for authentication state management with Firebase

import 'package:flutter/material.dart';
import '../models/models.dart';  // ✅ Updated import
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  // ─── Getters ──────────────────────────────────────────────────
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // ─── Initialize / Load User ───────────────────────────────────
  Future<void> init() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ─── Login ────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final result = await _authService.login(email: email, password: password);
      if (result != null) {
        _user = result;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Register ─────────────────────────────────────────────────
  Future<bool> register(String name, String email, String password, String role) async {
    _setLoading(true);
    _clearError();
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      if (result != null) {
        _user = result;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ─── Update User Profile ──────────────────────────────────────
  Future<bool> updateProfile({String? name, String? photoURL}) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.updateUserProfile(name: name, photoURL: photoURL);
      // Refresh user data
      _user = await _authService.getCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Reset Password ───────────────────────────────────────────
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.resetPassword(email);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Refresh User Data ────────────────────────────────────────
  Future<void> refreshUser() async {
    try {
      _user = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ─── Private Methods ──────────────────────────────────────────
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
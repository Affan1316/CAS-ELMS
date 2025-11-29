import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/shared_preference_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/workshop_geofencing/Data/services/geofence_sevice.dart';
import '../../../features/workshop_geofencing/Data/services/work_manager_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SharedPreferences keys
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyStudentId = 'studentId';
  static const String _keyUserEmail = 'userEmail';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sigInOut() async {
    await WorkManagerService.cancelWorkManger();
    await MyGeofenceService.dispose();
    await _auth.signOut();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get saved student ID
  Future<String?> getSavedStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStudentId);
  }

  // Get saved email
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // Save login state
  Future<void> _saveLoginState({
    required String studentId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyStudentId, studentId);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(SharedPreferenceKeys.rollNo, studentId);
  }

  // Clear login state
  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyStudentId);
    await prefs.remove(_keyUserEmail);
  }

  // Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String studentId,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login state
      await _saveLoginState(studentId: studentId, email: email);

      return AuthResult(
        user: result.user,
        success: true,
        message: 'Account created successfully!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        user: null,
        success: false,
        message: _getErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        user: null,
        success: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String studentId,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login state
      await _saveLoginState(studentId: studentId, email: email);

      return AuthResult(
        user: result.user,
        success: true,
        message: 'Signed in successfully!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        user: null,
        success: false,
        message: _getErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        user: null,
        success: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _clearLoginState();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper method to convert Firebase error codes to user-friendly messages
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'The credentials provided are invalid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

// Result class for authentication operations
class AuthResult {
  final User? user;
  final bool success;
  final String message;

  AuthResult({
    required this.user,
    required this.success,
    required this.message,
  });
}

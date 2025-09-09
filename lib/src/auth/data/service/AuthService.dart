import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

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

// admin_storage_service.dart (MODIFIED)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// ADD THIS ENUM HERE
enum AdminRole { none, admin, superAdmin }

class AdminStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _adminIdKey = 'admin_id';
  static const String _adminPasswordKey = 'admin_password';

  // --- ADDED ---
  static const String _superAdminIdKey = 'super_admin_id';
  static const String _superAdminPasswordKey = 'super_admin_password';
  // --- END ADDED ---

  static const String _isSetupCompleteKey = 'admin_setup_complete';

  static const String _isLoggedInKey = 'admin_is_logged_in';
  static const String _currentRoleKey = 'admin_current_role';
  static const String _loggedInAdminIdKey = 'admin_logged_in_id';

  // ADD THIS METHOD - Save login session
  static Future<void> saveLoginSession({
    required String adminId,
    required AdminRole role,
  }) async {
    try {
      await _storage.write(key: _isLoggedInKey, value: 'true');
      await _storage.write(key: _currentRoleKey, value: role.name);
      await _storage.write(key: _loggedInAdminIdKey, value: adminId);
      print('✅ Admin session saved: $adminId with role $role');
    } catch (e) {
      print('Error saving login session: $e');
      throw Exception('Failed to save session');
    }
  }

  // ADD THIS METHOD - Check if admin is logged in
  static Future<bool> isAdminLoggedIn() async {
    try {
      String? isLoggedIn = await _storage.read(key: _isLoggedInKey);
      return isLoggedIn == 'true';
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // ADD THIS METHOD - Get current admin role
  static Future<AdminRole> getCurrentRole() async {
    try {
      String? roleStr = await _storage.read(key: _currentRoleKey);
      if (roleStr == null) return AdminRole.none;

      return AdminRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => AdminRole.none,
      );
    } catch (e) {
      print('Error getting current role: $e');
      return AdminRole.none;
    }
  }

  // ADD THIS METHOD - Get logged in admin ID
  static Future<String?> getLoggedInAdminId() async {
    try {
      return await _storage.read(key: _loggedInAdminIdKey);
    } catch (e) {
      print('Error getting logged in admin ID: $e');
      return null;
    }
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> initializeDefaultAdmin() async {
    String? setupComplete = await _storage.read(key: _isSetupCompleteKey);
    if (setupComplete == null) {
      // Regular Admin
      await _storage.write(key: _adminIdKey, value: 'admin001');
      await _storage.write(
        key: _adminPasswordKey,
        value: _hashPassword('admin123'),
      );
      print('Default admin initialized: ID=admin001, Password=admin123');

      // --- ADDED: Super Admin ---
      await _storage.write(key: _superAdminIdKey, value: 'superadmin');
      await _storage.write(
        key: _superAdminPasswordKey,
        value: _hashPassword('super123'), // Give a different password
      );
      print(
        'Default super admin initialized: ID=superadmin, Password=super123',
      );
      // --- END ADDED ---

      await _storage.write(key: _isSetupCompleteKey, value: 'true');
    }
  }

  // --- MODIFIED: This function now returns an AdminRole ---
  // In AdminStorageService.dart -> verifyAdminLogin

  static Future<AdminRole> verifyAdminLogin(
    String adminId,
    String password,
  ) async {
    try {
      // Read all credentials
      String? storedAdminId = await _storage.read(key: _adminIdKey);
      String? storedAdminPassword = await _storage.read(key: _adminPasswordKey);
      String? storedSuperAdminId = await _storage.read(key: _superAdminIdKey);
      String? storedSuperAdminPassword = await _storage.read(
        key: _superAdminPasswordKey,
      );

      // --- MODIFIED THIS CHECK ---
      if (storedAdminId == null ||
          storedAdminPassword == null ||
          storedSuperAdminId == null ||
          storedSuperAdminPassword == null) {
        print('No stored credentials found or setup not complete');
        return AdminRole.none;
      }
      // --- END MODIFICATION ---

      String hashedInputPassword = _hashPassword(password);
      print('Input password hash: $hashedInputPassword');

      // Check for Admin
      if (storedAdminId == adminId &&
          storedAdminPassword == hashedInputPassword) {
        print('Login result: ADMIN');
        return AdminRole.admin;
      }

      // Check for Super Admin
      if (storedSuperAdminId == adminId &&
          storedSuperAdminPassword == hashedInputPassword) {
        print('Login result: SUPER ADMIN');
        return AdminRole.superAdmin;
      }

      // No match
      print('Login result: NONE');
      return AdminRole.none;
    } catch (e) {
      print('Error verifying admin login: $e');
      return AdminRole.none;
    }
  }
  // --- END MODIFIED ---

  // --- MODIFIED: Check both IDs ---
  static Future<bool> verifyAdminId(String adminId) async {
    try {
      String? storedAdminId = await _storage.read(key: _adminIdKey);
      String? storedSuperAdminId = await _storage.read(key: _superAdminIdKey);

      // Return true if it matches EITHER admin
      return (storedAdminId == adminId || storedSuperAdminId == adminId);
    } catch (e) {
      print('Error verifying admin ID: $e');
      return false;
    }
  }
  // --- END MODIFIED ---

  // --- MODIFIED: Find the correct user to update ---
  static Future<bool> changeAdminPassword(
    String adminId,
    String newPassword,
  ) async {
    try {
      String? storedAdminId = await _storage.read(key: _adminIdKey);
      String? storedSuperAdminId = await _storage.read(key: _superAdminIdKey);

      String hashedNewPassword = _hashPassword(newPassword);

      // Check if it's the regular admin
      if (storedAdminId == adminId) {
        await _storage.write(key: _adminPasswordKey, value: hashedNewPassword);
        print('Regular admin password changed');
        return true;
      }
      // Check if it's the super admin
      else if (storedSuperAdminId == adminId) {
        await _storage.write(
          key: _superAdminPasswordKey,
          value: hashedNewPassword,
        );
        print('Super admin password changed');
        return true;
      }

      // No user found
      return false;
    } catch (e) {
      print('Error changing admin password: $e');
      return false;
    }
  }
  // --- END MODIFIED ---

  static Future<String?> getAdminId() async {
    // This function might need rethinking. For now, it just gets the regular admin.
    // Your forget password flow doesn't use this, so it's okay for now.
    try {
      return await _storage.read(key: _adminIdKey);
    } catch (e) {
      print('Error getting admin ID: $e');
      return null;
    }
  }

  // --- MODIFIED: Clear all keys ---
  static Future<void> clearAdminData() async {
    try {
      await _storage.delete(key: _adminIdKey);
      await _storage.delete(key: _adminPasswordKey);
      await _storage.delete(key: _superAdminIdKey); // ADDED
      await _storage.delete(key: _superAdminPasswordKey); // ADDED
      await _storage.delete(key: _isSetupCompleteKey);
    } catch (e) {
      print('Error clearing admin data: $e');
    }
  }

  // --- END MODIFIED ---
  static Future<void> logout() async {
    try {
      // Clear session data
      await _storage.delete(key: _isLoggedInKey);
      await _storage.delete(key: _currentRoleKey);
      await _storage.delete(key: _loggedInAdminIdKey);
      await _storage.delete(key: 'session_token');
      await _storage.delete(key: 'last_login_time');

      print('✅ Logout successful - session cleared, credentials preserved');
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Logout failed');
    }
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AdminStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _adminIdKey = 'admin_id';
  static const String _adminPasswordKey = 'admin_password';
  static const String _isSetupCompleteKey = 'admin_setup_complete';

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> initializeDefaultAdmin() async {
    String? setupComplete = await _storage.read(key: _isSetupCompleteKey);
    if (setupComplete == null) {
      await _storage.write(key: _adminIdKey, value: 'admin001');
      await _storage.write(
        key: _adminPasswordKey,
        value: _hashPassword('admin123'),
      );
      await _storage.write(key: _isSetupCompleteKey, value: 'true');
      print('Default admin initialized: ID=admin001, Password=admin123');
    }
  }

  static Future<bool> verifyAdminLogin(String adminId, String password) async {
    try {
      String? storedId = await _storage.read(key: _adminIdKey);
      String? storedPassword = await _storage.read(key: _adminPasswordKey);

      print('Verifying login - StoredId: $storedId, InputId: $adminId');

      if (storedId == null || storedPassword == null) {
        print('No stored credentials found');
        return false;
      }

      String hashedInputPassword = _hashPassword(password);
      print('Stored password hash: $storedPassword');
      print('Input password hash: $hashedInputPassword');

      bool result =
          storedId == adminId && storedPassword == hashedInputPassword;
      print('Login result: $result');
      return result;
    } catch (e) {
      print('Error verifying admin login: $e');
      return false;
    }
  }

  static Future<bool> verifyAdminId(String adminId) async {
    try {
      String? storedId = await _storage.read(key: _adminIdKey);
      return storedId == adminId;
    } catch (e) {
      print('Error verifying admin ID: $e');
      return false;
    }
  }

  static Future<bool> changeAdminPassword(
    String adminId,
    String newPassword,
  ) async {
    try {
      bool isValidId = await verifyAdminId(adminId);
      if (!isValidId) return false;

      String hashedNewPassword = _hashPassword(newPassword);
      await _storage.write(key: _adminPasswordKey, value: hashedNewPassword);
      return true;
    } catch (e) {
      print('Error changing admin password: $e');
      return false;
    }
  }

  static Future<String?> getAdminId() async {
    try {
      return await _storage.read(key: _adminIdKey);
    } catch (e) {
      print('Error getting admin ID: $e');
      return null;
    }
  }

  static Future<void> clearAdminData() async {
    try {
      await _storage.delete(key: _adminIdKey);
      await _storage.delete(key: _adminPasswordKey);
      await _storage.delete(key: _isSetupCompleteKey);
    } catch (e) {
      print('Error clearing admin data: $e');
    }
  }
}

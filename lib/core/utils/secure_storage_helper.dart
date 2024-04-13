import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  static Future<void> saveData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getData({required String key}) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteData({required String key}) async {
    await _storage.delete(key: key);
  }
}
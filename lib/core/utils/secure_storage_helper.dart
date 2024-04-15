import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Helper class for securely storing data using Flutter Secure Storage.
class SecureStorageHelper {
  /// Flutter Secure Storage instance.
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  /// Saves data securely with the provided key.
  ///
  /// [key]: Key under which the data will be stored.
  /// [value]: Data to be stored securely.
  static Future<void> saveData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieves securely stored data associated with the provided key.
  ///
  /// [key]: Key associated with the data to be retrieved.
  ///
  /// Returns the stored data as a String, or null if no data is found.
  static Future<String?> getData({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Deletes securely stored data associated with the provided key.
  ///
  /// [key]: Key associated with the data to be deleted.
  static Future<void> deleteData({required String key}) async {
    await _storage.delete(key: key);
  }
}

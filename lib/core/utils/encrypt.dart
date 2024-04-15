import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Utility class for encryption and verification.
class Encrypt {
  /// Encrypts a string value using SHA-256 hashing algorithm.
  ///
  /// [value]: String value to encrypt.
  ///
  /// Returns the encrypted value as a hexadecimal string.
  static String encrypt(String value) {
    var bytes = utf8.encode(value);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies whether a string value matches its encrypted counterpart.
  ///
  /// [value]: Original string value.
  /// [encryptedValue]: Encrypted value to compare against.
  ///
  /// Returns true if the original value matches its encrypted counterpart, otherwise returns false.
  static bool verifyEncrypted(String value, String encryptedValue) {
    var bytes = utf8.encode(value);
    var digest = sha256.convert(bytes);

    return digest.toString() == encryptedValue;
  }
}

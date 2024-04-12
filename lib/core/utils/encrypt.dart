import 'dart:convert';

import 'package:crypto/crypto.dart';

class Encrypt {
  static String encrypt(String value) {
    var bytes = utf8.encode(value);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyEncrypted(String value, String encryptedValue) {
    var bytes = utf8.encode(value);
    var digest = sha256.convert(bytes);

    return digest.toString() == encryptedValue;
  }
}
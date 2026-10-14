import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

/// Provides encrypted backup serialization for local app data.
class BackupService {
  const BackupService._();

  static const String _versionPrefix = 'hisaab-backup-v1:';
  static const int _keyLength = 32;
  static const int _ivLength = 16;

  /// Encrypts a plain JSON payload using a passphrase-derived key.
  static Future<String> encryptPayload(
    String payload, {
    required String passphrase,
  }) async {
    final key = _deriveKey(passphrase);
    final iv = IV.fromLength(_ivLength);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(payload, iv: iv);

    final combined = Uint8List.fromList([
      ...iv.bytes,
      ...encrypted.bytes,
    ]);

    return '$_versionPrefix${base64.encode(combined)}';
  }

  /// Decrypts a previously exported payload and validates the passphrase.
  static Future<String> decryptPayload(
    String encryptedPayload, {
    required String passphrase,
  }) async {
    if (!encryptedPayload.startsWith(_versionPrefix)) {
      throw const FormatException('Invalid backup payload format.');
    }

    final encoded = encryptedPayload.substring(_versionPrefix.length);
    final combined = base64.decode(encoded);

    if (combined.length < _ivLength + 1) {
      throw const FormatException('Backup payload is too short.');
    }

    final iv = IV(Uint8List.fromList(combined.sublist(0, _ivLength)));
    final cipherBytes = combined.sublist(_ivLength);
    final key = _deriveKey(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    try {
      final decrypted = encrypter.decryptBytes(
        Encrypted(cipherBytes),
        iv: iv,
      );
      return utf8.decode(decrypted);
    } on Exception {
      throw const FormatException('Invalid backup passphrase or corrupted file.');
    }
  }

  static Key _deriveKey(String passphrase) {
    final bytes = utf8.encode(passphrase);
    final padded = List<int>.filled(_keyLength, 0, growable: false);

    for (var i = 0; i < _keyLength; i++) {
      padded[i] = bytes[i % bytes.length];
    }

    return Key(Uint8List.fromList(padded));
  }
}

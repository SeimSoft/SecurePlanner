import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final encryptionServiceProvider = Provider((ref) => EncryptionService());

class EncryptionService {
  final _algorithm = AesGcm.with256bits();

  /// Derives a 256-bit key from a password and salt using PBKDF2.
  Future<SecretKey> deriveKey(String password, List<int> salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );
    return await pbkdf2.deriveKeyFromPassword(password: password, nonce: salt);
  }

  /// Encrypts a string (JSON) using the provided key.
  Future<String> encrypt(String? data, SecretKey key) async {
    if (data == null) return "";
    final clearText = utf8.encode(data);
    final nonce = _algorithm.newNonce();
    final secretBox = await _algorithm.encrypt(
      clearText,
      secretKey: key,
      nonce: nonce,
    );

    // Combine nonce and cipher text for storage
    final combined = Uint8List(
      nonce.length + secretBox.cipherText.length + secretBox.mac.bytes.length,
    );
    combined.setAll(0, nonce);
    combined.setAll(nonce.length, secretBox.mac.bytes);
    combined.setAll(
      nonce.length + secretBox.mac.bytes.length,
      secretBox.cipherText,
    );

    return base64.encode(combined);
  }

  /// Decrypts a base64 string using the provided key.
  Future<String?> decrypt(String? encodedData, SecretKey key) async {
    if (encodedData == null || encodedData.isEmpty) return null;
    final combined = base64.decode(encodedData);

    final nonce = combined.sublist(0, 12);
    final mac = Mac(combined.sublist(12, 28));
    final cipherText = combined.sublist(28);

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clearText = await _algorithm.decrypt(secretBox, secretKey: key);

    return utf8.decode(clearText);
  }

  /// Generates a salt for a given password (deterministic for this app setup or random)
  List<int> generateSalt(String identifier) {
    return crypto.sha256.convert(utf8.encode(identifier)).bytes.sublist(0, 16);
  }
}

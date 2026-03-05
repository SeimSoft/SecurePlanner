import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final securityServiceProvider =
    Provider<SecurityService>((ref) => SecurityService());

class SecurityService {
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  static const _masterKeyAlias = 'master_key';
  static const _isSetupAlias = 'app_is_setup';
  static const _useBiometricsAlias = 'use_biometrics';

  Future<void> writeSecure(String key, String value) async {
    if (kIsWeb || (kDebugMode && Platform.isMacOS)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return;
    }
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint(
          'SecurityService: Secure Storage failed ($e), falling back to SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  Future<String?> readSecure(String key) async {
    if (kIsWeb || (kDebugMode && Platform.isMacOS)) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint(
          'SecurityService: Secure Storage failed ($e), falling back to SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  Future<void> deleteSecure(String key) async {
    if (kIsWeb || (kDebugMode && Platform.isMacOS)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return;
    }
    try {
      await _storage.delete(key: key);
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }
  }

  Future<bool> isAppSetup() async {
    final setup = await readSecure(_isSetupAlias);
    return setup == 'true';
  }

  Future<void> setupMasterKey(String password) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );
    final salt = [1, 2, 3, 4, 5, 6, 7, 8];
    final secretKey = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final keyBytes = await secretKey.extractBytes();

    await writeSecure(_masterKeyAlias, base64Encode(keyBytes));
    await writeSecure(_isSetupAlias, 'true');
  }

  Future<bool> canUseBiometrics() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    try {
      final canAuth = await canUseBiometrics();
      if (!canAuth) {
        debugPrint('SecurityService: Biometrics not supported/available');
        return false;
      }

      final result = await _auth.authenticate(
        localizedReason: 'Bitte authentifiziere dich, um die App zu öffnen',
      );
      debugPrint('SecurityService: Authentication result: $result');
      return result;
    } catch (e) {
      debugPrint('SecurityService: Authentication error: $e');
      return false;
    }
  }

  Future<void> setUseBiometrics(bool use) async {
    await writeSecure(_useBiometricsAlias, use.toString());
  }

  Future<bool> shouldPromptBiometrics() async {
    final use = await readSecure(_useBiometricsAlias);
    return use == 'true';
  }

  Future<bool> verifyPassword(String password) async {
    try {
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 10000,
        bits: 256,
      );
      final salt = [1, 2, 3, 4, 5, 6, 7, 8];
      final secretKey = await pbkdf2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final keyBytes = await secretKey.extractBytes();

      final storedKeyBase64 = await readSecure(_masterKeyAlias);
      if (storedKeyBase64 == null) return false;

      final storedKey = base64Decode(storedKeyBase64);
      return listEquals(keyBytes, storedKey);
    } catch (e) {
      return false;
    }
  }

  Future<List<int>?> getMasterKey() async {
    final keyBase64 = await readSecure(_masterKeyAlias);
    if (keyBase64 == null) return null;
    return base64Decode(keyBase64);
  }
}

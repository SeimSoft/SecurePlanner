import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:private_planner/services/api_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(baseDioProvider);
  return AuthService(dio);
});

class AuthService {
  final Dio _dio;
  String? _baseUrl;
  String? _authToken;
  bool _initialized = false;

  AuthService(this._dio);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    const storage = FlutterSecureStorage();
    _baseUrl = await storage.read(key: 'server_url');
    _authToken = await storage.read(key: 'auth_token');
    _initialized = true;
  }

  set baseUrl(String? url) {
    if (url != null && url.endsWith('/')) {
      _baseUrl = url.substring(0, url.length - 1);
    } else {
      _baseUrl = url;
    }
    const storage = FlutterSecureStorage();
    storage.write(key: 'server_url', value: _baseUrl);
    _initialized = true;
  }

  String? get baseUrl {
    // This is synchronous, but the first call to auth might need the value.
    // In Flutter, we often initialize this via a FutureProvider or similar.
    // For now, we'll try to load it.
    return _baseUrl;
  }

  Future<String?> get baseUrlAsync async {
    await _ensureInitialized();
    return _baseUrl;
  }

  Future<String?> get authToken async {
    await _ensureInitialized();
    return _authToken;
  }

  Future<String?> login(String username, String password) async {
    await _ensureInitialized();
    if (_baseUrl == null) throw Exception('Server URL not set');
    try {
      final response = await _dio.post('$_baseUrl/login', data: {
        'username': username,
        'password': password,
      });
      final token = response.data['token'];
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: token);
      _authToken = token;
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> loginWithQr(String qrData) async {
    try {
      final data = jsonDecode(qrData);
      final url = data['url'] as String;
      final token = data['token'] as String;

      baseUrl = url;
      final response = await _dio.post('$url/qr-login', data: {
        'token': token,
      });

      final jwt = response.data['token'];
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: jwt);
      await storage.write(key: 'server_url', value: url);
      _authToken = jwt;
      _initialized = true;
      return jwt;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    _authToken = null;
  }

  Future<void> disconnect() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'server_url');
    await storage.delete(key: 'auth_token');
    _baseUrl = null;
    _authToken = null;
    _initialized = false;
  }
}

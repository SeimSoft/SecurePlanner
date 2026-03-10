import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:private_planner/services/api_provider.dart';
import 'package:private_planner/services/security_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(baseDioProvider);
  final securityService = ref.watch(securityServiceProvider);
  return AuthService(dio, securityService);
});

class AuthService {
  final Dio _dio;
  final SecurityService _securityService;
  String? _baseUrl;
  String? _authToken;
  bool _initialized = false;

  AuthService(this._dio, this._securityService);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _baseUrl = await _securityService.readSecure('server_url');
    _authToken = await _securityService.readSecure('auth_token');
    _initialized = true;
  }

  set baseUrl(String? url) {
    if (url != null && url.endsWith('/')) {
      _baseUrl = url.substring(0, url.length - 1);
    } else {
      _baseUrl = url;
    }
    _securityService.writeSecure('server_url', _baseUrl ?? '');
    _initialized = true;
  }

  String? get baseUrl {
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
      await _securityService.writeSecure('auth_token', token);
      _authToken = token;
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> loginWithQr(String qrData) async {
    try {
      String decodedData = qrData;
      if (!qrData.startsWith('{')) {
        try {
          decodedData = utf8.decode(base64Decode(qrData));
        } catch (_) {
          // Keep as is, might be raw json
        }
      }

      final data = jsonDecode(decodedData);
      final url = data['url'] as String;
      final token = data['token'] as String;

      baseUrl = url;
      final response = await _dio.post('$url/qr-login', data: {
        'token': token,
      });

      final jwt = response.data['token'];
      await _securityService.writeSecure('auth_token', jwt);
      await _securityService.writeSecure('server_url', url);
      _authToken = jwt;
      _initialized = true;
      return jwt;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _securityService.deleteSecure('auth_token');
    _authToken = null;
  }

  Future<void> disconnect() async {
    await _securityService.deleteSecure('server_url');
    await _securityService.deleteSecure('auth_token');
    _baseUrl = null;
    _authToken = null;
    _initialized = false;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  // Add interceptor for auth header
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));
  return dio;
});

final authServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
});

class AuthService {
  final Dio _dio;
  String? baseUrl;
  String? _authToken;

  AuthService(this._dio);

  Future<String?> get authToken async {
    if (_authToken != null) return _authToken;
    const storage = FlutterSecureStorage();
    _authToken = await storage.read(key: 'auth_token');
    return _authToken;
  }

  Future<String?> login(String username, String password) async {
    if (baseUrl == null) throw Exception('Server URL not set');
    try {
      final response = await _dio.post('$baseUrl/login', data: {
        'username': username,
        'password': password,
      });
      final token = response.data['token'];
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: token);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String password) async {
    if (baseUrl == null) throw Exception('Server URL not set');
    await _dio.post('$baseUrl/register', data: {
      'username': username,
      'password': password,
    });
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
  }
}

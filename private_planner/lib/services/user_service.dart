import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/api_provider.dart';
import 'package:private_planner/services/auth_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  final authService = ref.watch(authServiceProvider);
  return UserService(dio, authService);
});

class UserService {
  final Dio _dio;
  final AuthService _auth;

  UserService(this._dio, this._auth);

  Future<String?> uploadProfilePicture(File file) async {
    final baseUrl = _auth.baseUrl;
    if (baseUrl == null) throw Exception('Server URL not set');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });

    final response =
        await _dio.post('$baseUrl/api/profile/picture', data: formData);
    if (response.statusCode == 200) {
      return response.data['path'] as String;
    }
    return null;
  }

  Future<String?> createHousehold() async {
    final baseUrl = _auth.baseUrl;
    if (baseUrl == null) throw Exception('Server URL not set');

    final response = await _dio.post('$baseUrl/api/household/create');
    if (response.statusCode == 200) {
      return response.data['token'] as String;
    }
    return null;
  }

  Future<void> joinHousehold(String token) async {
    final baseUrl = _auth.baseUrl;
    if (baseUrl == null) throw Exception('Server URL not set');

    await _dio.post('$baseUrl/api/household/join', data: {'token': token});
  }
}

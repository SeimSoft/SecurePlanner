import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';

// Base Dio for unauthenticated requests (like login)
final baseDioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Authenticated Dio adds the token interceptor
final authenticatedDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await ref.read(authServiceProvider).authToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));
  return dio;
});

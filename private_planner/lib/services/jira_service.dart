import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JiraService {
  static const _storage = FlutterSecureStorage();
  static const _userKey = 'jira_username';
  static const _passKey = 'jira_password';

  static Future<Map<String, String?>> getStoredCredentials() async {
    final user = await _storage.read(key: _userKey);
    final pass = await _storage.read(key: _passKey);
    return {'username': user, 'password': pass};
  }

  static Future<void> storeCredentials(String username, String password) async {
    await _storage.write(key: _userKey, value: username);
    await _storage.write(key: _passKey, value: password);
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _passKey);
  }

  // Extract issue key from a JIRA browse URL like /browse/ANAGEN-2758
  static String? _extractKeyFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      final idx = segments.indexOf('browse');
      if (idx >= 0 && idx + 1 < segments.length) {
        return segments[idx + 1];
      }
      // fallback: last segment
      if (segments.isNotEmpty) return segments.last;
    } catch (_) {}
    return null;
  }

  // Build API base from URL
  static String? _buildApiUrl(String url, String key) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}/rest/api/2/issue/$key';
    } catch (_) {
      return null;
    }
  }

  // Fetch issue summary and description. Throws on error.
  static Future<Map<String, String>> fetchIssueFromUrl(
      String url, String username, String password) async {
    final key = _extractKeyFromUrl(url);
    if (key == null) throw Exception('Could not extract issue key from URL');
    final api = _buildApiUrl(url, key);
    if (api == null) throw Exception('Invalid URL');

    final dio = Dio();
    final token = base64Encode(utf8.encode('$username:$password'));
    try {
      final resp = await dio.get(api,
          options: Options(headers: {'Authorization': 'Basic $token'}),
          queryParameters: {'fields': 'summary,description'});
      final data = resp.data;
      final fields = data['fields'] ?? {};
      final summary = (fields['summary'] ?? '').toString();
      final description = (fields['description'] ?? '').toString();
      return {'key': key, 'summary': summary, 'description': description};
    } on DioException catch (e) {
      throw Exception('Failed to fetch issue: ${e.message}');
    }
  }
}

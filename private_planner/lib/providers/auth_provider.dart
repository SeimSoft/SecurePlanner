import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';

final authStatusProvider = StateProvider<bool>((ref) => false);

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(false);

  Future<void> login(String username, String password, String url) async {
    _authService.baseUrl = url;
    await _authService.login(username, password);
    state = true;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = false;
  }
}

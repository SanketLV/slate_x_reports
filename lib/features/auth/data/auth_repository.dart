import 'package:slate_x_reports/core/models/api_auth_response.dart';
import 'package:slate_x_reports/features/auth/data/auth_service.dart';
import 'package:slate_x_reports/features/auth/models/restaurant_details.dart';
import 'package:slate_x_reports/features/auth/models/user.dart';

class AuthRepository {
  final AuthService _service;
  AuthRepository(this._service);

  Future<ApiAuthResponse<User>> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> logout() => _service.logout();
  Future<bool> isLoggedIn() => _service.isLoggedIn();
  Future<String?> getToken() => _service.getToken();
  Future<ApiAuthResponse<RestaurantDetails>> getCurrentUser() =>
      _service.getCurrentUser();
}

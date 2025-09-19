import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:slate_x_reports/core/models/api_response.dart';
import 'package:slate_x_reports/core/network/api_service.dart';
import 'package:slate_x_reports/features/auth/models/restaurant_details.dart';
import 'package:slate_x_reports/features/auth/models/user.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<ApiAuthResponse<User>> login(String email, String password) async {
    log("Sending email: $email, password: $password");
    log("Headers: ${{"Content-Type": "application/json"}}");
    log("Body: ${jsonEncode({"email": email, "password": password})}");

    final response = await ApiService.post<User>(
      "/employee/login",
      body: {"email_address": email, "password": password},
      fromJson: (json) => User.fromJson(json),
    );

    log("Status Code: ${response.isSuccess}");

    if (response.isSuccess && response.result != null) {
      //* Save token securely
      await _storage.write(key: "auth_token", value: response.result!.token);
      log("AuthService - Login successful, token saved");
    } else {
      log("AuthService - Login failed: ${response.message}");
    }
    return response;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: "auth_token");
  }

  Future<void> logout() async {
    await _storage.delete(key: "auth_token");
    log("AuthService - User logged out, token removed");
  }

  //* Method to check if user is already logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  //* Method to get current user details
  Future<ApiAuthResponse<RestaurantDetails>> getCurrentUser() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return ApiAuthResponse.error("No Authentication token found");
    }

    try {
      log("AuthService - Fetching restaurant details with token");

      final response = await ApiService.post<RestaurantDetails>(
        "/getRestaurantDetails",
        body: {},
        headers: {'Authorization': 'Bearer $token'},
        fromJson: (json) => RestaurantDetails.fromJson(json),
      );

      if (response.isSuccess) {
        log("AuthService - Restaurant details fetched successfully");
      } else {
        log(
          "AuthService - Failed to fetch restaurant details: ${response.message}",
        );
      }

      return response;
    } catch (e) {
      log("AuthService - Error fetching restaurant details: $e");
      return ApiAuthResponse.error(
        "Failed to fetch user details: ${e.toString()}",
      );
    }
  }
}

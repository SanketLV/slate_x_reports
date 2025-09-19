import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:slate_x_reports/features/auth/data/auth_repository.dart';
import 'package:slate_x_reports/features/auth/models/restaurant_details.dart';
import 'package:slate_x_reports/features/auth/models/user.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final User? user;
  final RestaurantDetails? restaurantDetails;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.restaurantDetails,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    User? user,
    RestaurantDetails? restaurantDetails,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      restaurantDetails: restaurantDetails ?? this.restaurantDetails,
      error: error,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthViewModel(this._repo) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repo.login(email, password);

      if (response.isSuccess && response.result != null) {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          user: response.result,
          error: null,
        );
        log(
          "AuthViewModel - Login successful for user: ${response.result!.firstName}",
        );

        //* Load current user details after login
        await getCurrentUser();
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          user: null,
          error: response.message,
        );
        log("AuthViewModel - Login failed: ${response.message}");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        user: null,
        error: "An unexpected error occured: ${e.toString()}",
      );
      log("AuthViewModel - Login error: $e");
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  void logout() {
    _repo.logout();
    state = AuthState();
    log("AuthViewModel - User logged out");
  }

  //* method to check if user is already logged in
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _repo.isLoggedIn();
      if (isLoggedIn) {
        state = state.copyWith(isLoading: false, isLoggedIn: true);
        await getCurrentUser();
      } else {
        state = state.copyWith(isLoading: false, isLoggedIn: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        user: null,
        error: "Failed to check authentication status",
      );
    }
  }

  //* Method to fetch currentUser
  Future<void> getCurrentUser() async {
    try {
      final response = await _repo.getCurrentUser();

      if (response.isSuccess && response.result != null) {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          restaurantDetails: response.result,
          error: null,
        );
        log("AuthViewModel - Current User's details fetched successfully");
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          restaurantDetails: null,
          error: response.message,
        );
        log(
          "AuthViewModel - Failed to fetched current user's details: ${response.message}",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        restaurantDetails: null,
        error: "Failed to fetch current user's details: ${e.toString()}",
      );
      log("AuthViewModel - Error fetching current user's details: $e");
    }
  }
}

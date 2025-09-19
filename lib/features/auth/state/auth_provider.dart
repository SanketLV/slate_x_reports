import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:slate_x_reports/features/auth/data/auth_repository.dart';
import 'package:slate_x_reports/features/auth/data/auth_service.dart';
import 'package:slate_x_reports/features/auth/state/auth_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(authServiceProvider)),
);

final authProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(ref.read(authRepositoryProvider)),
);

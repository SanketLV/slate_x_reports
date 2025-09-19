import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slate_x_reports/core/widgets/loading_screen.dart';
import 'package:slate_x_reports/features/auth/state/auth_provider.dart';
import 'package:slate_x_reports/features/auth/ui/pages/home_page.dart';
import 'package:slate_x_reports/features/auth/ui/pages/login_page.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _hasCheckedAuth = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    if (!_hasCheckedAuth) {
      await ref.read(authProvider.notifier).checkAuthStatus();
      _hasCheckedAuth = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return LoadingScreen();
    }

    if (authState.isLoggedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}

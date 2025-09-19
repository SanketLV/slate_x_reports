import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slate_x_reports/features/auth/state/auth_provider.dart';
import 'package:slate_x_reports/features/auth/ui/pages/forgot_password_page.dart';
import 'package:slate_x_reports/features/auth/ui/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isPasswordVIsible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.user != null && !next.isLoading) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      } else if (next.error != null && next.error!.isNotEmpty) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //* Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                //* Card Container
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //* Greeting Message
                        Text(
                          'Welcome Back! 👋',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sign in to continue to Slatex POS',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 40),
                        //* Email Field
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !authState.isLoading,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            hintText: "Enter your email",
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email address";
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        //* Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordVIsible,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.visiblePassword,
                          enabled: !authState.isLoading,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVIsible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVIsible = !_isPasswordVIsible;
                                });
                              },
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                        //* Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                        //* Submit Button
                        IgnorePointer(
                          ignoring: authState.isLoading,
                          child: GestureDetector(
                            onTap: authState.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await ref
                                          .read(authProvider.notifier)
                                          .login(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                          );
                                    }
                                  },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                // color: Colors.black,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff4b5563),
                                    Color(0xff374151),
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: authState.isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                //* Footer
                Text(
                  "© 2025 Slatex POS. All Rights Reserved.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

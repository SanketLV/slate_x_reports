import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final bool dark;

  const LoadingScreen({
    super.key,
    this.message = "Loading...",
    this.dark = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.black : Colors.white;
    final fg = dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              height: 80,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 32),

            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),

            SizedBox(height: 16),

            Text(message, style: TextStyle(color: fg, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HourlySalesPage extends StatefulWidget {
  const HourlySalesPage({super.key});

  @override
  State<HourlySalesPage> createState() => _HourlySalesPageState();
}

class _HourlySalesPageState extends State<HourlySalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Hourly Sales Page")],
        ),
      ),
    );
  }
}

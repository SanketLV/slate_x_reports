import 'package:flutter/material.dart';

class CategorySalesPage extends StatefulWidget {
  const CategorySalesPage({super.key});

  @override
  State<CategorySalesPage> createState() => _CategorySalesPageState();
}

class _CategorySalesPageState extends State<CategorySalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Category Sales Page")],
        ),
      ),
    );
  }
}

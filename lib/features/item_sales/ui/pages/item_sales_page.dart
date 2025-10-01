import 'package:flutter/material.dart';

class ItemSalesPage extends StatefulWidget {
  const ItemSalesPage({super.key});

  @override
  State<ItemSalesPage> createState() => _ItemSalesPageState();
}

class _ItemSalesPageState extends State<ItemSalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Item Sales Page")],
        ),
      ),
    );
  }
}

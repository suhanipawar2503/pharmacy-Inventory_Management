import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/common/placeholder_screen.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: "Sales Records",
      actions: [
        IconButton(
          icon: const Icon(Icons.receipt_long),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createBill),
        ),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sales History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context, 
                AppRoutes.invoice,
                arguments: 'S5001',
              ),
              icon: const Icon(Icons.receipt),
              label: const Text("View Sample Invoice"),
            ),
          ],
        ),
      ),
    );
  }
}

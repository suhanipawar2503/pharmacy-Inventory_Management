import 'package:flutter/material.dart';
import '../widgets/common/placeholder_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: "Reports & Analytics",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Business Reports",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Sales and Inventory analytics will appear here."),
          ],
        ),
      ),
    );
  }
}

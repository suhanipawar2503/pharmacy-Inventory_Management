import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/placeholder_screen.dart';
import '../routes/app_routes.dart';
import '../providers/pharmacy_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    
    return PlaceholderScreen(
      title: "Pharmacy Profile",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.local_pharmacy, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              "Smart Care Pharmacy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(provider.userEmail),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PharmacyProvider>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

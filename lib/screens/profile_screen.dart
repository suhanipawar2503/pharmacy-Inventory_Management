import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Shop Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 16),

              // Contact & Shop Info Card
              _buildCredentialsCard(provider.userEmail),
              const SizedBox(height: 16),

              // Settings Actions List
              _buildSettingsCard(context),
              const SizedBox(height: 16),

              // Logout Button
              CustomButton(
                text: "Logout",
                containerColor: AppColors.alertRedLight,
                contentColor: AppColors.alertRed,
                icon: Icons.logout,
                onPressed: () => _showLogoutDialog(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primaryBlueLight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_pharmacy,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Smart Care Pharmacy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              "License No: 20B/MH-102938",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Owner: Dr. Alex Morgan",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsCard(String email) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      color: AppColors.surfaceWhite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pharmacy Credentials & Contact",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Divider(height: 24, color: AppColors.surfaceBorder),
            _buildInfoRow(Icons.email_outlined, "Pharmacist Email", email),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone_outlined, "Store Contact", "+91 98200 44556"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on_outlined, "Store Address", "Plot 12, Healthcare Zone, City Center"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.receipt_outlined, "GSTIN", "27ABCDE1234F1Z5"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      color: AppColors.surfaceWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSettingsItem(
              context,
              Icons.settings_outlined,
              "System Settings",
              "Low stock alert threshold, GST configuration",
            ),
            const Divider(height: 1, color: AppColors.surfaceBorder),
            _buildSettingsItem(
              context,
              Icons.backup_outlined,
              "Data Backup & Export",
              "Export local dummy database to CSV",
            ),
            const Divider(height: 1, color: AppColors.surfaceBorder),
            _buildSettingsItem(
              context,
              Icons.help_outline,
              "Help & Support",
              "Documentation and user guide",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title feature coming soon")),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlueLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, PharmacyProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Logout from System?",
        message: "Are you sure you want to end your session? You will return to the Login screen.",
        confirmText: "Logout",
        isDanger: true,
        onConfirm: () {
          provider.logout();
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        },
        onDismiss: () {},
      ),
    );
  }
}

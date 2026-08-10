import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/pharmacy_utils.dart';
import '../providers/pharmacy_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/detail_row.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String medicineId;

  const ProductDetailsScreen({
    super.key,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PharmacyProvider>();
    final medicine = provider.medicines.firstWhere(
      (m) => m.id == medicineId,
      orElse: () => throw Exception("Medicine not found"),
    );

    final isExpired = PharmacyUtils.isExpired(medicine.expiryDate);
    final isExpiringSoon = PharmacyUtils.isExpiringIn30Days(medicine.expiryDate);
    final profit = (medicine.sellingPrice - medicine.purchasePrice).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        title: const Text(
          "Product Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.editProduct,
              arguments: medicine.id,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.alertRed),
            onPressed: () => _showDeleteDialog(context, provider, medicine.name),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(medicine),
            const SizedBox(height: 16),

            // Status Badges Row
            Row(
              children: [
                Expanded(
                  child: _buildStatusBadge(
                    title: "Current Stock",
                    value: "${medicine.quantity} units",
                    isAlert: medicine.quantity <= medicine.minStockThreshold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildExpiryBadge(
                    medicine.expiryDate,
                    isExpired,
                    isExpiringSoon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Specification Grid Card
            _buildSpecificationCard(medicine, profit),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.editProduct,
                      arguments: medicine.id,
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Product"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(context, provider, medicine.name),
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.alertRed,
                      side: const BorderSide(color: AppColors.alertRed),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(dynamic medicine) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primaryBlueLight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication,
                color: AppColors.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medicine.company,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      medicine.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required String title,
    required String value,
    required bool isAlert,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isAlert ? AppColors.alertRedLight : AppColors.successGreenLight,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Stock",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isAlert ? AppColors.alertRed : AppColors.successGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryBadge(String expiryDate, bool isExpired, bool isExpiringSoon) {
    Color bgColor;
    Color textColor;
    String status;

    if (isExpired) {
      bgColor = AppColors.alertRedLight;
      textColor = AppColors.alertRed;
      status = "EXPIRED";
    } else if (isExpiringSoon) {
      bgColor = AppColors.warningOrangeLight;
      textColor = AppColors.warningOrange;
      status = "Expiring Soon";
    } else {
      bgColor = AppColors.primaryBlueLight;
      textColor = AppColors.primaryBlue;
      status = expiryDate;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expiry Status",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationCard(dynamic medicine, double profit) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      color: AppColors.surfaceWhite,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pricing & Batch Information",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Divider(height: 24, color: AppColors.surfaceBorder),
            DetailRow(label: "Batch Number", value: medicine.batchNumber),
            DetailRow(label: "Purchase Price", value: "₹${medicine.purchasePrice}"),
            DetailRow(label: "Selling Price (MRP)", value: "₹${medicine.sellingPrice}"),
            DetailRow(
              label: "Margin / Profit",
              value: "₹${profit.toStringAsFixed(2)}",
              valueColor: AppColors.successGreen,
            ),
            DetailRow(label: "Expiry Date", value: medicine.expiryDate),
            DetailRow(label: "Distributor", value: medicine.distributorName),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PharmacyProvider provider,
    String medicineName,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Delete Product?",
        message:
            "Are you sure you want to remove $medicineName from inventory? This action cannot be undone.",
        onConfirm: () {
          provider.deleteMedicine(medicineId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$medicineName deleted")),
          );
          Navigator.pop(context);
        },
        onDismiss: () => {},
      ),
    );
  }
}

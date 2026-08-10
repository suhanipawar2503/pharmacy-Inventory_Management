import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final bool isExpired;
  final bool isExpiringSoon;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    this.isExpired = false,
    this.isExpiringSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    if (isExpired) {
      statusColor = AppColors.alertRed;
      statusBgColor = AppColors.alertRedLight;
    } else if (isExpiringSoon) {
      statusColor = AppColors.warningOrange;
      statusBgColor = AppColors.warningOrangeLight;
    } else if (medicine.quantity <= medicine.minStockThreshold) {
      statusColor = AppColors.alertRed;
      statusBgColor = AppColors.alertRedLight;
    } else {
      statusColor = AppColors.primaryBlue;
      statusBgColor = AppColors.primaryBlueLight;
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      color: AppColors.surfaceWhite,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // Medicine Pill Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication,
                  color: statusColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${medicine.company} • ${medicine.category}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${medicine.sellingPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Exp: ${medicine.expiryDate}',
                            style: TextStyle(
                              fontSize: 11,
                              color: (isExpired || isExpiringSoon) ? statusColor : AppColors.textMuted,
                              fontWeight: (isExpired || isExpiringSoon) ? FontWeight.bold : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Stock Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStockStatusBgColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${medicine.quantity} in stock',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStockStatusColor(),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStockStatusColor() {
    if (medicine.quantity == 0) return AppColors.alertRed;
    if (medicine.quantity <= medicine.minStockThreshold) return AppColors.warningOrange;
    return AppColors.successGreen;
  }

  Color _getStockStatusBgColor() {
    if (medicine.quantity == 0) return AppColors.alertRedLight;
    if (medicine.quantity <= medicine.minStockThreshold) return AppColors.warningOrangeLight;
    return AppColors.successGreenLight;
  }
}

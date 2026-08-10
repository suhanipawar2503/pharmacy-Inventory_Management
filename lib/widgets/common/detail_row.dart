import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color valueColor;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

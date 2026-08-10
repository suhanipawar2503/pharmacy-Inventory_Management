import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;
  final String confirmText;
  final String dismissText;
  final bool isDanger;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onDismiss,
    this.confirmText = 'Delete',
    this.dismissText = 'Cancel',
    this.isDanger = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surfaceWhite,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            onDismiss();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDanger ? AppColors.alertRed : AppColors.primaryBlue,
            foregroundColor: AppColors.onPrimaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

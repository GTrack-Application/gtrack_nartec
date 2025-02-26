import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class AppSnackbars {
  static void danger(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.red.shade700,
      icon: Icons.error_outline,
      iconColor: AppColors.white,
    );
  }

  static void normal(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: AppColors.black.withValues(alpha: 0.9),
      icon: Icons.info_outline,
      iconColor: AppColors.white,
    );
  }

  static void success(BuildContext context, String message, [int? duration]) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.white,
      duration: duration,
    );
  }

  static void warning(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.amber.shade700,
      icon: Icons.warning_amber_outlined,
      iconColor: AppColors.white,
    );
  }

  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    int? duration,
  }) {
    // Clean message by removing "Exception:" prefix
    final cleanMessage = message.replaceAll("Exception:", "").trim();

    // Hide any existing snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cleanMessage,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: Duration(seconds: duration ?? 3),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: AppColors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 6,
      ),
    );
  }
}

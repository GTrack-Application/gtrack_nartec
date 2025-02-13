import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class AppToast {
  static success(BuildContext context, message) {
    _appToast(context, message, AppColors.success);
  }

  static danger(BuildContext context, message) {
    _appToast(context, message, AppColors.danger);
  }

  static normal(BuildContext context, message) {
    _appToast(context, message, AppColors.black);
  }
}

void _appToast(BuildContext context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message.toString().replaceAll("Exception:", "")),
      backgroundColor: color,
    ),
  );
}

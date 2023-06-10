// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrettyToast {
  PrettyToast.success(
    BuildContext context,
    String message, {
    bool? isDark = false,
    Duration? duration,
  }) {
    Get.showSnackbar(
      GetBar(
        message: message,
        duration: duration ?? const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  PrettyToast.error(
    BuildContext context,
    String message, {
    bool? isDark = false,
    Duration? duration,
  }) {
    Get.showSnackbar(
      GetBar(
        message: message.replaceAll('Exception: ', ''),
        duration: duration ?? const Duration(seconds: 5),
        // backgroundGradient: LinearGradient(colors: [
        //   Colors.red.shade500,
        //   Colors.red.shade600,
        //   Colors.red.shade700,
        //   Colors.red.shade800,
        // ]),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

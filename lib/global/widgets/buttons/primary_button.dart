import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroungColor,
    this.fontSize,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback onPressed;
  final Color? backgroungColor;
  final double? fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroungColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize ?? 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.fontSize,
    this.isLoading = false,
    this.loadingColor,
    this.height,
    this.width,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? fontSize;
  final bool isLoading;
  final Color? loadingColor;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height ?? 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? AppColors.white,
                  ),
                ),
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

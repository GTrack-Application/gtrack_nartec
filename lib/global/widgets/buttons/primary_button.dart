import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroungColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

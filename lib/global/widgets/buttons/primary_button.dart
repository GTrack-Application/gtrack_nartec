import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroungColor,
    this.fontSize,
  });
  final String text;
  final VoidCallback onPressed;
  final Color? backgroungColor;
  final double? fontSize;

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
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

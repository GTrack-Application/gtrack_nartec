import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class CardIconButton extends StatelessWidget {
  const CardIconButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  final String text;
  final String icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.background,
          border: Border.all(
            color: AppColors.black,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              icon,
            ),
            const Spacer(),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

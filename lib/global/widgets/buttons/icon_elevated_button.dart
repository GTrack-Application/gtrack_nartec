import 'package:flutter/material.dart';

class IconElevatedButton extends StatelessWidget {
  const IconElevatedButton({
    super.key,
    this.text,
    this.leadingIcon,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
  });
  final String? text;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: Row(
        children: [
          leadingIcon ?? const SizedBox.shrink(),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed ?? () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor ?? Colors.white,
                backgroundColor:
                    backgroundColor ?? Theme.of(context).primaryColor,
              ),
              child: Text(text ?? 'Text'),
            ),
          ),
        ],
      ),
    );
  }
}

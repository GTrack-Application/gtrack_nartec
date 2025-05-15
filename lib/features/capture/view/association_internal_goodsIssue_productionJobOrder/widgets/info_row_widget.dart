import 'package:flutter/material.dart';

class InfoRowWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? iconColor;
  final double iconSize;

  const InfoRowWidget({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.iconColor,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    final defaultValueStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: iconColor ?? Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Text(
            '$label: ',
            style: labelStyle ?? defaultLabelStyle,
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? defaultValueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

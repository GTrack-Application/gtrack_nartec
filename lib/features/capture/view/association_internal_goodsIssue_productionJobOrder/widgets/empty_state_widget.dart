import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? iconColor;
  final double iconSize;
  final TextStyle? messageStyle;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.inventory_2_outlined,
    this.message = 'No items found',
    this.iconColor,
    this.iconSize = 48,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: messageStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

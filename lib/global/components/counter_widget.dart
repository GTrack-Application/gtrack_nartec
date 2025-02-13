import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    this.onPlusPressed,
    this.onMinusPressed,
    this.quantity,
  });

  final VoidCallback? onPlusPressed;
  final VoidCallback? onMinusPressed;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.success,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPlusPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: onMinusPressed,
            icon: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

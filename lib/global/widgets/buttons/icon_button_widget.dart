import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final String text;
  final String? description;
  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.text,
    this.description,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Image.asset(icon),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        // if (description != null) Text(description!),
      ],
    );
  }
}

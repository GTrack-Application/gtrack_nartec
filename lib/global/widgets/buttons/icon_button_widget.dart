import 'package:auto_size_text/auto_size_text.dart';
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
        SizedBox(
          height: 200,
          child: AutoSizeText(
            text,
          ),
        ),
        if (description != null) Text(description!),
      ],
    );
  }
}

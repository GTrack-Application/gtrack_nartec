import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 95,
          width: 95,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Image.asset(
            icon,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Placeholder(),
          ),
        ),
        // const SizedBox(height: 5),
        SizedBox(
          width: 95,
          height: 50,
          child: Text(
            text,
            softWrap: true,
            maxLines: 10,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}

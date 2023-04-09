import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.text,
    this.margin,
  });

  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ??
          EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.20,
            right: MediaQuery.of(context).size.width * 0.23,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        child: Text(
          text ?? "Text",
        ),
      ),
    );
  }
}

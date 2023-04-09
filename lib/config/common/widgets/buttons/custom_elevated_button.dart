import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomElevatedButton extends StatefulWidget {
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
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: widget.margin ??
          EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.20,
            right: MediaQuery.of(context).size.width * 0.23,
          ),
      child: ElevatedButton(
        onPressed: () {
          if (_isLoading == true) return;
          toggleLoading();
          widget.onPressed?.call();
          toggleLoading();
        },
        child: _isLoading == true
            ? Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: Colors.white,
                  size: 20,
                ),
              )
            : Text(
                widget.text ?? "Text",
              ),
      ),
    );
  }
}

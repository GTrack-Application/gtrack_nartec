import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.text,
    this.margin,
    this.width,
  });

  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsetsGeometry? margin;
  final double? width;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: 50,
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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

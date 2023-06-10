import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/my_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
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
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
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
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.secondary,
        ),
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

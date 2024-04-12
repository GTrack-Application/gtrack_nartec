import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText,
    this.width,
    this.leadingIcon,
    this.suffixIcon,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.enabled,
    this.hintText,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final double? width;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final bool? enabled;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled ?? true,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: textInputAction ?? TextInputAction.done,
      focusNode: focusNode ?? FocusNode(),
      onFieldSubmitted: onFieldSubmitted ?? (value) {},
      validator: validator ??
          (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: AppColors.fields,
        filled: true,
        hintStyle: const TextStyle(
          color: AppColors.grey,
        ),
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.danger,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

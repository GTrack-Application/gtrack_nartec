import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class IconTextField extends StatelessWidget {
  const IconTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.leadingIcon,
    this.textInputAction,
    this.focusNode,
    this.enabled,
    this.obscureText,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: textInputAction ?? TextInputAction.done,
      // focusNode: focusNode ?? FocusNode(),
      // onFieldSubmitted: (value) {
      //   if (textInputAction == TextInputAction.next) {
      //     FocusScope.of(context).nextFocus();
      //   } else if (textInputAction == TextInputAction.done) {
      //     FocusScope.of(context).unfocus();
      //     hideKeyboard(context);
      //   }
      // },
      validator: validator ??
          (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
      decoration: InputDecoration(
        fillColor: AppColors.fields,
        filled: true,
        // prefixIcon: leadingIcon ?? const SizedBox.shrink(),
        suffixIcon: suffixIcon ?? const SizedBox.shrink(),
        icon: leadingIcon ?? const SizedBox.shrink(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

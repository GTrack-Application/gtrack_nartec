import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

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
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   color: const Color.fromRGBO(255, 255, 255, 1),
      // ),
      // height: 50,
      child: TextFormField(
        controller: controller,
        enabled: enabled ?? true,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction ?? TextInputAction.done,
        focusNode: focusNode ?? FocusNode(),
        onFieldSubmitted: onFieldSubmitted ?? (value) {},
        // validator: validator ??
        //     (String? value) {
        //       if (value == null || value.isEmpty) {
        //         return 'Please enter some text';
        //       }
        //       return null;
        //     },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.fields,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hintText,
          fillColor: AppColors.fields,
          filled: true,
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
          suffixIcon: suffixIcon ?? const SizedBox.shrink(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: InputBorder.none,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.danger,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

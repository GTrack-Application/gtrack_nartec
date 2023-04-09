import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.emailController,
    this.keyboardType,
    this.validator,
    this.obscureText,
    this.width,
    this.leadingIcon,
    this.suffixIcon,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final TextEditingController emailController;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final double? width;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      // height: 4
      child: TextFormField(
        controller: emailController,
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
          icon: leadingIcon ?? const SizedBox.shrink(),
          fillColor: const Color.fromRGBO(236, 244, 249, 1),
          filled: true,
          suffixIcon: suffixIcon ?? const SizedBox.shrink(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),

          // enabledBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Colors.grey,
          //     width: 2.0,
          //   ),
          // ),
        ),
      ),
    );
  }
}

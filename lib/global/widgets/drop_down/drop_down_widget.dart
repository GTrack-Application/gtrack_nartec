import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class DropDownWidget<T> extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.items,
    required this.value,
    required this.displayItemFn,
    this.onChanged,
    this.width,
    this.height,
    this.hintText,
    this.labelText,
    this.readOnly = false,
    this.validator,
    this.color,
    this.autofocus = false,
    this.focusNode,
    this.suffixIcon,
  });

  final List<T> items;
  final T? value;
  final String Function(T) displayItemFn;
  final Function(T?)? onChanged;
  final double? width;
  final double? height;
  final String? hintText;
  final String? labelText;
  final bool readOnly;
  final String? Function(T?)? validator;
  final Color? color;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      height: height ?? 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? AppColors.background,
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: const EdgeInsets.only(
            top: 15,
            left: 10,
          ),
          hintText: hintText ?? '',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: AppColors.white,
        focusNode: focusNode,
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayItemFn(item),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ))
            .toList(),
        onChanged: readOnly ? null : onChanged,
        validator: validator,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({super.key, this.items, this.value, this.onChanged});

  final List<String>? items;
  final String? value;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.fields,
        border: Border.all(width: 1),
      ),
      child: DropdownButton(
        isExpanded: true,
        elevation: 0,
        value: value,
        items: items?.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged ?? (_) {},
      ),
    );
  }
}

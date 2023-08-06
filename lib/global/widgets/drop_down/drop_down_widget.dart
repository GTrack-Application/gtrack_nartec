import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
  });

  final List<String> items;
  final String value;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.fields,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
        color: AppColors.fields,
      ),
      child: DropdownButton(
        value: value,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        underline: const SizedBox(),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: AutoSizeText(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

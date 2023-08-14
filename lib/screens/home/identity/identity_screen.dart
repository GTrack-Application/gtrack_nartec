import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/icon_button_widget.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  final List<Map> data = [
    {
      "text": "GTIN",
      "icon": AppIcons.gtin,
    },
    {
      "text": "GLN",
      "icon": AppIcons.gln,
    },
    {
      "text": "SSCC",
      "icon": AppIcons.sscc,
    },
    {
      "text": "GIAI",
      "icon": AppIcons.giai,
    },
    {
      "text": "GRAI",
      "icon": AppIcons.grai,
    },
    {
      "text": "GMN",
      "icon": AppIcons.gmn,
    },
    {
      "text": "GSRN",
      "icon": AppIcons.gsrn,
    },
    {
      "text": "GSIN",
      "icon": AppIcons.gsin,
    }
  ];

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: GridView.builder(
        gridDelegate: gridDelegate,
        itemBuilder: (context, index) {
          return IconButtonWidget(
            icon: data[index]["icon"] as String,
            onPressed: () {},
            text: data[index]['text'] as String,
          );
        },
        itemCount: data.length,
      ),
    );
  }
}

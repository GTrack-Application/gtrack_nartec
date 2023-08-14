import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/icon_button_widget.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final List<Map> data = [
    {
      "text": "ASSOCIATION",
      "icon": AppIcons.gtin,
    },
    {
      "text": "TRANSFORMATION",
      "icon": AppIcons.gln,
    },
    {
      "text": "AGGREGATION",
      "icon": AppIcons.sscc,
    },
    {
      "text": "SERIALIZATION",
      "icon": AppIcons.giai,
    },
    {
      "text": "MAPPING BARCODE",
      "icon": AppIcons.grai,
    },
  ];

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    childAspectRatio: 1,
    crossAxisCount: 3,
    mainAxisSpacing: 30,
    crossAxisSpacing: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
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
      ),
    );
  }
}

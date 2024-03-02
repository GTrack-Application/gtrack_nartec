import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class TransformationScreen extends StatefulWidget {
  const TransformationScreen({super.key});

  @override
  State<TransformationScreen> createState() => _TransformationScreenState();
}

class _TransformationScreenState extends State<TransformationScreen> {
  final List<Map> data = [
    {
      "text": "Manufacturing",
      "icon": AppIcons.transManufacturing,
    },
    {
      "text": "Processing",
      "icon": AppIcons.transProcessing,
    },
    {
      "text": "Repackaging",
      "icon": AppIcons.transRepackaging,
    },
    {
      "text": "Refurbishing",
      "icon": AppIcons.transRefining,
    },
    {
      "text": "Reprocessing",
      "icon": AppIcons.transReprocessing,
    },
    {
      "text": "Repurposing",
      "icon": AppIcons.transRepurposing,
    },
    {
      "text": "Converting",
      "icon": AppIcons.transConverting,
    },
    {
      "text": "Refining",
      "icon": AppIcons.transRefining,
    },
    {
      "text": "Modifying",
      "icon": AppIcons.transModifying,
    },
    {
      "text": "Customizing",
      "icon": AppIcons.transCustomizing,
    },
  ];

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.6,
    crossAxisSpacing: 20,
    mainAxisSpacing: 50,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRANSFORMATION'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: gridDelegate,
              itemBuilder: (context, index) {
                return CardIconButton(
                  icon: data[index]["icon"] as String,
                  onPressed: () {},
                  text: data[index]['text'] as String,
                );
              },
              itemCount: data.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            ),
          ],
        ),
      ),
    );
  }
}

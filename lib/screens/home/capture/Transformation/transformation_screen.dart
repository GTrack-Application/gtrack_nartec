import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/widgets/card_icon_button.dart';

class TransformationScreen extends StatefulWidget {
  const TransformationScreen({super.key});

  @override
  State<TransformationScreen> createState() => _TransformationScreenState();
}

class _TransformationScreenState extends State<TransformationScreen> {
  final List<Map> data = [
    {
      "text": "Manufacturing",
      "icon": AppIcons.association,
    },
    {
      "text": "Processing",
      "icon": AppIcons.transformation,
    },
    {
      "text": "Packaging",
      "icon": AppIcons.aggregation,
    },
    {
      "text": "Refurbishing",
      "icon": AppIcons.serialization,
    },
    {
      "text": "Reprocessing",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Repurposing",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Converting",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Refining",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Modifying",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Customizing",
      "icon": AppIcons.mapping,
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

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class AggregationScreen extends StatefulWidget {
  const AggregationScreen({super.key});

  @override
  State<AggregationScreen> createState() => _AggregationScreenState();
}

class _AggregationScreenState extends State<AggregationScreen> {
  final List<Map> data = [
    {
      "text": "Packaging",
      "icon": AppIcons.aggPackaging,
    },
    {
      "text": "Packing",
      "icon": AppIcons.aggPacking,
    },
    {
      "text": "Combining",
      "icon": AppIcons.aggCombining,
    },
    {
      "text": "Assembling",
      "icon": AppIcons.aggAssembling,
    },
    {
      "text": "Grouping",
      "icon": AppIcons.aggGrouping,
    },
    {
      "text": "Bundling",
      "icon": AppIcons.aggBundling,
    },
    {
      "text": "Batching",
      "icon": AppIcons.aggBatching,
    },
    {
      "text": "Consolidating",
      "icon": AppIcons.aggConsolidating,
    },
    {
      "text": "Compiling",
      "icon": AppIcons.aggCompiling,
    },
    {
      "text": "Containerization",
      "icon": AppIcons.aggContainerization,
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
        title: const Text('AGGREGRATION'),
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

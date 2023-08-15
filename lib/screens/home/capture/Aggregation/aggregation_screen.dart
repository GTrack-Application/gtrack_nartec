import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/widgets/card_icon_button.dart';

class AggregationScreen extends StatefulWidget {
  const AggregationScreen({super.key});

  @override
  State<AggregationScreen> createState() => _AggregationScreenState();
}

class _AggregationScreenState extends State<AggregationScreen> {
  final List<Map> data = [
    {
      "text": "Packaging",
      "icon": AppIcons.association,
    },
    {
      "text": "Packing",
      "icon": AppIcons.transformation,
    },
    {
      "text": "Combining",
      "icon": AppIcons.aggregation,
    },
    {
      "text": "Assembling",
      "icon": AppIcons.serialization,
    },
    {
      "text": "Grouping",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Bundling",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Batching",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Consolidating",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Compiling",
      "icon": AppIcons.mapping,
    },
    {
      "text": "Containerization",
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
        title: const Text('Association'),
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

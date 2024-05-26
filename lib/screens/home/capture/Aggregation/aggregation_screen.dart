import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Assembling/assembling_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Bundling/bundling_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Palletization/new_palletization_screen.dart';

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
      "onTap": () {},
    },
    {
      "text": "Packing",
      "icon": AppIcons.aggPacking,
      "onTap": () {},
    },
    {
      "text": "Combining",
      "icon": AppIcons.aggCombining,
      "onTap": () {},
    },
    {
      "text": "Assembling",
      "icon": AppIcons.aggAssembling,
      "onTap": () {},
    },
    {
      "text": "Grouping",
      "icon": AppIcons.aggGrouping,
      "onTap": () {},
    },
    {
      "text": "Bundling",
      "icon": AppIcons.aggBundling,
      "onTap": () {},
    },
    {
      "text": "Batching",
      "icon": AppIcons.aggBatching,
      "onTap": () {},
    },
    {
      "text": "Consolidating",
      "icon": AppIcons.aggConsolidating,
      "onTap": () {},
    },
    {
      "text": "Palletization",
      "icon": AppIcons.aggCompiling,
      "onTap": () {},
    },
    {
      "text": "Containerization",
      "icon": AppIcons.aggContainerization,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    data[8]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const NewPalletizationScreen());
    data[5]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const BundlingScreen());
    data[3]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const AssemblingScreen());
  }

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
                  onPressed: data[index]["onTap"],
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

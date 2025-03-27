import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/packaging/packaging_by_many_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/palletization_containerization/palletization_screen.dart';

import 'aggregation_new/screens/packaging/packaging_screen.dart';
import 'aggregation_new/screens/palletization_containerization/sscc_container_screen.dart';

class AggregationScreen extends StatefulWidget {
  const AggregationScreen({super.key});

  @override
  State<AggregationScreen> createState() => _AggregationScreenState();
}

class _AggregationScreenState extends State<AggregationScreen> {
  final List<Map> data = [
    {
      "text": "Packaging By Carton",
      "icon": AppIcons.aggPackaging,
      "onTap": () {},
    },
    {
      "text": "Packaging By Pack",
      "icon": AppIcons.aggPacking,
      "onTap": () {},
    },
    {
      "text": "Combining",
      "icon": AppIcons.aggCombining,
      "onTap": () {},
    },
    {
      "text": "Pack By Assembly",
      "icon": AppIcons.aggAssembling,
      "onTap": () {},
    },
    {
      "text": "Grouping",
      "icon": AppIcons.aggGrouping,
      "onTap": () {},
    },
    {
      "text": "Packaging By Bundle",
      "icon": AppIcons.aggBundling,
      "onTap": () {},
    },
    {
      "text": "Pack By Batches",
      "icon": AppIcons.aggBatching,
      "onTap": () {},
    },
    {
      "text": "Consolidating",
      "icon": AppIcons.aggConsolidating,
      "onTap": () {},
    },
    {
      "text": "Pack By Pallets",
      "icon": AppIcons.aggCompiling,
      "onTap": () {},
    },
    {
      "text": "Pack By SSCC Container",
      "icon": AppIcons.aggContainerization,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    data[0]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingByCartonScreen(
          type: "box_carton",
          description: "Packaging By Carton",
          floatingActionButtonText: "Perform Packaging By Carton",
        ));
    data[1]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingScreen(
          packagingType: "packing_by_pack",
          title: "Packaging By Pack",
        ));
    data[3]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingScreen(
          packagingType: "assembling",
          title: "Pack By Assembly",
        ));
    data[4]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingByCartonScreen(
          type: "grouping",
          description: "Grouping",
          floatingActionButtonText: "Perform Aggregation By Grouping",
        ));
    data[5]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingScreen(
          packagingType: "packing_by_bundle",
          title: "Packaging By Bundle",
        ));
    data[6]["onTap"] = () => AppNavigator.goToPage(
        context: context,
        screen: const PackagingByCartonScreen(
          type: "batching",
          description: "Pack By Batches",
          floatingActionButtonText: "Perform Aggregation By Batches",
        ));
    data[8]["onTap"] = () => AppNavigator.goToPage(
          context: context,
          screen: const PalletizationScreen(),
        );
    data[9]["onTap"] = () => AppNavigator.goToPage(
          context: context,
          screen: const SSCCContainerScreen(),
        );
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

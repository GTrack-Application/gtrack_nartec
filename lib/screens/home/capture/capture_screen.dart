import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/aggregation_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/association_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/MappingRFID/mapping_rfid_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Mapping_Barcode/BarcodeMappingScreen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Transformation/transformation_screen.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final List<Map> data = [
    {
      "text": "ASSOCIATION",
      "icon": AppIcons.association,
      "onTap": () {},
    },
    {
      "text": "TRANSFORMATION",
      "icon": AppIcons.transformation,
      "onTap": () {},
    },
    {
      "text": "AGGREGATION",
      "icon": AppIcons.aggregation,
      "onTap": () {},
    },
    {
      "text": "SERIALIZATION",
      "icon": AppIcons.serialization,
      "onTap": () {},
    },
    {
      "text": "MAPPING BARCODE",
      "icon": AppIcons.mapping,
      "onTap": () {},
    },
    {
      "text": "MAPPING RFID",
      "icon": AppIcons.mappingRFID,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    data[0]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const AssociationScreen());
    data[1]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const TransformationScreen());
    data[2]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const AggregationScreen());
    data[4]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: BarcodeMappingScreen());
    data[5]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const MappingRFIDScreen());
    super.initState();
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
        title: const Text('Capture'),
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

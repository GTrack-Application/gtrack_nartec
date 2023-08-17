import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/identify/GLN/gln_screen.dart';
import 'package:gtrack_mobile_app/screens/identify/GTIN/gtin_screen.dart';

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
      "desctiption": "Global Trade\nItem Number",
      "onTap": () {},
    },
    {
      "text": "GLN",
      "icon": AppIcons.gln,
      "desctiption": "Global Location\nNumber",
      "onTap": () {},
    },
    {
      "text": "SSCC",
      "icon": AppIcons.sscc,
      "desctiption": "Serial Shipping\nContainer Code",
      "onTap": () {},
    },
    {
      "text": "GIAI",
      "icon": AppIcons.giai,
      "desctiption": "Global Individual\nAsset Identifier",
      "onTap": () {},
    },
    {
      "text": "GRAI",
      "icon": AppIcons.grai,
      "desctiption": "Global Returnable\nAsset Identifier",
      "onTap": () {},
    },
    {
      "text": "GMN",
      "icon": AppIcons.gmn,
      "desctiption": "Global Model\nNumber",
      "onTap": () {},
    },
    {
      "text": "GSRN",
      "icon": AppIcons.gsrn,
      "desctiption": "Global Service\nRelation Number",
      "onTap": () {},
    },
    {
      "text": "GSIN",
      "icon": AppIcons.gsin,
      "desctiption": "Global Shipment\nIdentification Number",
      "onTap": () {},
    }
  ];

  @override
  void initState() {
    super.initState();
    data[0]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const GTINScreen());
    data[1]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const GLNScreen());
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
        title: const Text('Identify'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: gridDelegate,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                itemBuilder: (context, index) {
                  return CardIconButton(
                    icon: data[index]["icon"] as String,
                    onPressed: data[index]["onTap"],
                    text: data[index]['text'] as String,
                  );
                },
                itemCount: data.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

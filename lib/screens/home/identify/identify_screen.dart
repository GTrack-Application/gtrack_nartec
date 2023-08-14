import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/components/app_logo.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/icon_button_widget.dart';
import 'package:nb_utils/nb_utils.dart';

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
    },
    {
      "text": "GLN",
      "icon": AppIcons.gln,
      "desctiption": "Global Location\nNumber",
    },
    {
      "text": "SSCC",
      "icon": AppIcons.sscc,
      "desctiption": "Serial Shipping\nContainer Code",
    },
    {
      "text": "GIAI",
      "icon": AppIcons.giai,
      "desctiption": "Global Individual\nAsset Identifier",
    },
    {
      "text": "GRAI",
      "icon": AppIcons.grai,
      "desctiption": "Global Returnable\nAsset Identifier",
    },
    {
      "text": "GMN",
      "icon": AppIcons.gmn,
      "desctiption": "Global Model\nNumber",
    },
    {
      "text": "GSRN",
      "icon": AppIcons.gsrn,
      "desctiption": "Global Service\nRelation Number",
    },
    {
      "text": "GSIN",
      "icon": AppIcons.gsin,
      "desctiption": "Global Shipment\nIdentification Number",
    }
  ];

  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 0.8,
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
              10.height,
              const AppLogo(
                height: 150,
                width: 150,
              ),
              20.height,
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: gridDelegate,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                itemBuilder: (context, index) {
                  return IconButtonWidget(
                    icon: data[index]["icon"] as String,
                    onPressed: () {},
                    text: data[index]['text'] as String,
                    description: data[index]["desctiption"] as String,
                    fontSize: 12,
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

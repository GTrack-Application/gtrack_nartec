import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final List<Map> data = [
    {
      "text": "DIGITAL LINKS",
      "icon": AppIcons.digital,
    },
    {
      "text": "PRODUCT CATALOGUE",
      "icon": AppIcons.productCatalogue,
    },
    {
      "text": "PRODUCT CERTIFATES",
      "icon": AppIcons.productCertificate,
    },
    {
      "text": "EPCIS",
      "icon": AppIcons.epcis,
    },
    {
      "text": "CVB",
      "icon": AppIcons.cvb,
    },
    {
      "text": "PRODUCT ORIGIN",
      "icon": AppIcons.productOrigin,
    },
    {
      "text": "TRACEABILITY",
      "icon": AppIcons.traceability,
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
        title: const Text('Share'),
        backgroundColor: AppColors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: gridDelegate,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              itemBuilder: (context, index) {
                return CardIconButton(
                  icon: data[index]["icon"] as String,
                  onPressed: () {},
                  text: data[index]['text'] as String,
                );
              },
              itemCount: data.length,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class ConsignmentScreen extends StatefulWidget {
  const ConsignmentScreen({super.key});

  @override
  State<ConsignmentScreen> createState() => _ConsignmentScreenState();
}

class _ConsignmentScreenState extends State<ConsignmentScreen> {
  final List<Map> data = [
    {
      "text": "Shipper",
      "icon": AppIcons.consignShipper,
      "onTap": () {},
    },
    {
      "text": "Receiver",
      "icon": AppIcons.consignReceiver,
      "onTap": () {},
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
        title: const Text('Consignment'),
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

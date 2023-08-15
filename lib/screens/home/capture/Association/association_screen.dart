import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/widgets/card_icon_button.dart';

class AssociationScreen extends StatefulWidget {
  const AssociationScreen({super.key});

  @override
  State<AssociationScreen> createState() => _AssociationScreenState();
}

class _AssociationScreenState extends State<AssociationScreen> {
  final List<Map> data = [
    {
      "text": "Receiving",
      "icon": AppIcons.assoReceiving,
    },
    {
      "text": "Shipping",
      "icon": AppIcons.assoShipping,
    },
    {
      "text": "Handover",
      "icon": AppIcons.assoHandover,
    },
    {
      "text": "Ownership Transfer",
      "icon": AppIcons.assoOwnershipTransfer,
    },
    {
      "text": "Acceptance",
      "icon": AppIcons.assoAcceptance,
    },
    {
      "text": "Handoff",
      "icon": AppIcons.assoHandoff,
    },
    {
      "text": "Consignment",
      "icon": AppIcons.assoConsignment,
    },
    {
      "text": "Receipt",
      "icon": AppIcons.assoReceipt,
    },
    {
      "text": "Transfer",
      "icon": AppIcons.assoTransfer,
    },
    {
      "text": "Allocation",
      "icon": AppIcons.assoAllocation,
    },
    {
      "text": "Mapping",
      "icon": AppIcons.assoMapping,
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
        title: const Text('ACCOCIATION'),
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

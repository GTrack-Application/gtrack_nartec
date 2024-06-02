import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Consignment/consignment_screen.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Mapping/mapping_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/receiving_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Shipping/shipping_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Transfer/transfer_screen.dart';

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
      "onTap": () {},
    },
    {
      "text": "Shipping",
      "icon": AppIcons.assoShipping,
      "onTap": () {},
    },
    {
      "text": "Handover",
      "icon": AppIcons.assoHandover,
      "onTap": () {},
    },
    {
      "text": "Ownership Transfer",
      "icon": AppIcons.assoOwnershipTransfer,
      "onTap": () {},
    },
    {
      "text": "Acceptance",
      "icon": AppIcons.assoAcceptance,
      "onTap": () {},
    },
    {
      "text": "Handoff",
      "icon": AppIcons.assoHandoff,
      "onTap": () {},
    },
    {
      "text": "Consignment",
      "icon": AppIcons.assoConsignment,
      "onTap": () {},
    },
    {
      "text": "Receipt",
      "icon": AppIcons.assoReceipt,
      "onTap": () {},
    },
    {
      "text": "Internal Transfer",
      "icon": AppIcons.assoTransfer,
      "onTap": () {},
    },
    {
      "text": "Allocation",
      "icon": AppIcons.assoAllocation,
      "onTap": () {},
    },
    {
      "text": "Mapping",
      "icon": AppIcons.assoMapping,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    data[0]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const ReceivingScreen());
    data[1]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const ShippingScreen());
    data[6]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: const ConsignmentScreen());
    data[8]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const TransferScreen());
    data[10]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: const MappingScreen());
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
        title: const Text('ASSOCIATION'),
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

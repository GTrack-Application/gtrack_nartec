import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';

class RawMaterialsScreen extends StatefulWidget {
  const RawMaterialsScreen({super.key});

  @override
  State<RawMaterialsScreen> createState() => _RawMaterialsScreenState();
}

class _RawMaterialsScreenState extends State<RawMaterialsScreen> {
  final List<Map> data = [
    {
      "text": "Direct Receipt",
      "icon": AppIcons.directReceipt,
      "onTap": () {},
    },
    {
      "text": "Advanced Shipping Notice (ASN)",
      "icon": AppIcons.asn,
      "onTap": () {},
    },
    {
      "text": "Purchase Order Receipts",
      "icon": AppIcons.purchaseOrderReceipt,
      "onTap": () {},
    },
    {
      "text": "Return Receipts",
      "icon": AppIcons.returnReceipt,
      "onTap": () {},
    },
    {
      "text": "Internal Receipts",
      "icon": AppIcons.internalReceipt,
      "onTap": () {},
    },
    {
      "text": "Drop-Ship Receipt",
      "icon": AppIcons.dropshipReceipt,
      "onTap": () {},
    },
    {
      "text": "QA Receipt",
      "icon": AppIcons.qaReceipt,
      "onTap": () {},
    },
    {
      "text": "BackOrder Receipt",
      "icon": AppIcons.backorderReceipt,
      "onTap": () {},
    },
    {
      "text": "Cross Docking",
      "icon": AppIcons.crossDocking,
      "onTap": () {},
    },
    {
      "text": "Batch/Lot Receipt",
      "icon": AppIcons.batchLotReceipt,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    // data[0]["onTap"] = () => AppNavigator.goToPage(
    //     context: context, screen: RawMaterialsToWIPScreen1());
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
        title: const Text('Raw Materials'),
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

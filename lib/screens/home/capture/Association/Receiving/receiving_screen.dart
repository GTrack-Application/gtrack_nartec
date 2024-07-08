import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/CustomerReturns/ReturnRMAScreen1.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/SupplierReceipt/supplier_receipt_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/direct_receipt/direct_receipt_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Transfer/BinToBinTransfer/BinToBinInternalScreen.dart';

class ReceivingScreen extends StatefulWidget {
  const ReceivingScreen({super.key});

  @override
  State<ReceivingScreen> createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen> {
  final List<Map> data = [
    {
      "text": "Stock Transfer",
      "icon": AppIcons.recStock,
      "onTap": () {},
    },
    {
      "text": "Customer Returns",
      "icon": AppIcons.recCustomer,
      "onTap": () {},
    },
    {
      "text": "Supplier Receipt",
      "icon": AppIcons.recSupplier,
      "onTap": () {},
    },
    {
      "text": "Vendor Returns",
      "icon": AppIcons.recVendor,
      "onTap": () {},
    },
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
    data[0]['onTap'] = () {
      AppNavigator.goToPage(
          context: context, screen: const BinToBinInternalScreen());
    };
    data[1]['onTap'] = () {
      AppNavigator.goToPage(context: context, screen: const ReturnRMAScreen1());
    };
    data[2]['onTap'] = () {
      AppNavigator.goToPage(
          context: context, screen: const SupplierReveiptScreen());
    };
    data[4]["onTap"] = () => AppNavigator.goToPage(
          context: context,
          screen: const DirectReceiptScreen(),
        );
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
        title: const Text('Receiving'),
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

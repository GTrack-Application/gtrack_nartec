import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/image_button.dart';

class ReceivingScreen extends StatelessWidget {
  const ReceivingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppImages.receiptPageBG),
            AppBar(title: const Text('WPS PRO')),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: AppIcons.foreignPO,
                      text: 'Foreign PO',
                    ),
                    buttonTwo: ImageButton(
                      icon: AppIcons.salesOrder,
                      text: 'Sales Order',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: AppIcons.directSalesReturn,
                      text: 'Direct Sales Return',
                    ),
                    buttonTwo: ImageButton(
                      icon: AppIcons.stockTransfer,
                      text: 'Stock Transfer',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: AppIcons.directInvoice,
                      text: 'Direct Invoice',
                    ),
                    buttonTwo: ImageButton(
                      icon: AppIcons.fgGoodsReceipt,
                      text: 'FG Goods Receipts',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: AppIcons.salesReturnInvoice,
                      text: 'Sales Return Invoice',
                    ),
                    buttonTwo: ImageButton(
                      icon: AppIcons.goodsIssuedProduction,
                      text: 'Goods Issued (Production)',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class CustomImageButtonRow extends StatelessWidget {
  const CustomImageButtonRow({
    super.key,
    required this.buttonOne,
    required this.buttonTwo,
  });

  final ImageButton buttonOne;
  final ImageButton buttonTwo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buttonOne,
        buttonTwo,
      ],
    );
  }
}

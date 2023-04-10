import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/image_button.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';

class ReceiptManagementPage extends StatelessWidget {
  const ReceiptManagementPage({super.key});
  static const String pageName = '/receiptManagement-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(Images.receiptPageBG),
            AppBar(
              title: const Text('WPS PRO'),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: const [
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: CustomIcons.foreignPO,
                      text: 'Foreign PO',
                    ),
                    buttonTwo: ImageButton(
                      icon: CustomIcons.salesOrder,
                      text: 'Sales Order',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: CustomIcons.directSalesReturn,
                      text: 'Direct Sales Return',
                    ),
                    buttonTwo: ImageButton(
                      icon: CustomIcons.stockTransfer,
                      text: 'Stock Transfer',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: CustomIcons.directInvoice,
                      text: 'Direct Invoice',
                    ),
                    buttonTwo: ImageButton(
                      icon: CustomIcons.fgGoodsReceipt,
                      text: 'FG Goods Receipts',
                    ),
                  ),
                  // SizedBox(height: 10),
                  CustomImageButtonRow(
                    buttonOne: ImageButton(
                      icon: CustomIcons.salesReturnInvoice,
                      text: 'Sales Return Invoice',
                    ),
                    buttonTwo: ImageButton(
                      icon: CustomIcons.goodsIssuedProduction,
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

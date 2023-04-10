import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';

class ReceiptManagementPage extends StatelessWidget {
  const ReceiptManagementPage({super.key});
  static const String pageName = '/receiptManagement-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Image.asset(Images.receiptPageBG),
          AppBar(
            title: const Text('WPS PRO'),
            centerTitle: true,
          ),
        ],
      ),
    ));
  }
}

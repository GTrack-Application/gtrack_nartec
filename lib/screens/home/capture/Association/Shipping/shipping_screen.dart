import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/job_order/shipping_job_order_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/sales_order_screen.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final List<Map> data = [
    {
      "text": "Sales Order",
      "icon": AppIcons.shippingSales,
      "onTap": () {},
    },
    {
      "text": "Job Order",
      "icon": AppIcons.shippingWarehouse,
      "onTap": () {},
    },
  ];

  @override
  void initState() {
    super.initState();
    data[0]["onTap"] = () =>
        AppNavigator.goToPage(context: context, screen: SalesOrderScreen());
    data[1]["onTap"] = () => AppNavigator.goToPage(
        context: context, screen: ShippingJobOrderScreen());
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
        title: const Text('Shipping'),
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

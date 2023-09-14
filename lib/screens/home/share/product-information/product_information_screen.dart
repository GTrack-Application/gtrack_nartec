import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/events_screen.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/gtin_information_screen.dart';

class ProductInformationScreen extends StatefulWidget {
  final String gtin;
  final String codeType;
  const ProductInformationScreen(
      {super.key, required this.gtin, required this.codeType});

  @override
  State<ProductInformationScreen> createState() =>
      _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  final List<Tab> myTabs = const <Tab>[
    Tab(text: 'GTIN Information'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Events'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Information'),
          backgroundColor: AppColors.green,
          bottom: TabBar(
            tabs: myTabs,
            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.white,
            labelColor: AppColors.white,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Widget for Tab 1
            GtinInformationScreen(
              gtin: widget.gtin,
              codeType: widget.codeType,
            ),

            // Widget for Tab 2
            const Center(
              child: Text('This is Tab 2'),
            ),

            EventsScreen(
              gtin: widget.gtin,
              codeType: widget.codeType,
            ),
          ],
        ),
      ),
    );
  }
}

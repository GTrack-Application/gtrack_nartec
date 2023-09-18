import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/digital_link_screen.dart';
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
    Tab(text: 'Digital Links'),
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
            dividerColor: AppColors.primary,

            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColors.white,
            unselectedLabelColor: AppColors.white,
            labelColor: AppColors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            indicatorPadding: const EdgeInsets.all(8.0),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: 1,
              height: 1,
              fontFamily: 'Poppins',
              decoration: TextDecoration.none,
              decorationColor: AppColors.white,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            physics: const BouncingScrollPhysics(),
            // do not change with the swipe
            onTap: (index) {},
            // do not change with the swipe
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            GtinInformationScreen(gtin: widget.gtin, codeType: widget.codeType),
            DigitalLinkScreen(gtin: widget.gtin, codeType: widget.codeType),
            EventsScreen(gtin: widget.gtin, codeType: widget.codeType),
          ],
        ),
      ),
    );
  }
}

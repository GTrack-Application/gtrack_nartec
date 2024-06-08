import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/codification_screen.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/company_information.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/digital_link_screen.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/gtin_information_screen.dart';
import 'package:gtrack_mobile_app/screens/home/share/traceability/traceability_screen.dart';

class ProductInformationScreen extends StatefulWidget {
  final String gtin;
  const ProductInformationScreen({
    super.key,
    required this.gtin,
  });

  @override
  State<ProductInformationScreen> createState() =>
      _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  final List<Tab> myTabs = const <Tab>[
    Tab(text: 'GTIN Information'),
    Tab(text: 'Company Information'),
    Tab(text: 'Digital Links'),
    Tab(text: 'Events'),
    Tab(text: "Codification"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length, // Replace with the actual length of your tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: const Text('Product Information'),
          bottom: TabBar(
            tabs: myTabs,
            dividerColor: AppColors.green,
            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColors.white,
            unselectedLabelColor: AppColors.white,
            labelColor: AppColors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            indicatorPadding: const EdgeInsets.all(8.0),
            labelStyle: const TextStyle(
              fontSize: 13,
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
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            onTap: (index) {
              FocusScope.of(context).unfocus();
            },
            // physics:
            //     const NeverScrollableScrollPhysics(), // Disable tab swiping
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            GtinInformationScreen(gtin: widget.gtin),
            CompanyInformationScreen(gtin: widget.gtin),
            DigitalLinkScreen(gtin: widget.gtin),
            TraceabilityScreen(gtin: widget.gtin),
            CodificationScreen(gtin: widget.gtin),
          ],
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/receiving/receiving_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data = {
    "icon": [
      AppImages.identify,
      AppImages.capture,
      AppImages.share,
    ],
    "title": [
      "IDENTIFY",
      "CAPTURE",
      "SHARE",
    ],
    "caption": [
      "GTIN|GLN|SSCC|GIAI|GRAI GMN|GSRN|GSIN",
      "ASSOCIATION|TRANSFORMATION AGGREGATION|SERIALIZATION|MAPPING BARCODE AND RFID",
      "DIGITAL LINKS|PRODUCT CATALOGUE|PRODUCTS CERTIFICATES|EPCIS|CBV PRODUCTS ORIGIN|TRACEABILITY"
    ],
    "color": [
      AppColors.identify,
      AppColors.capture,
      AppColors.share,
    ],
    "onTap": [
      () {},
      () {},
      () {},
    ],
  };

  @override
  void initState() {
    super.initState();
    data['onTap']?[1] = () {
      AppNavigator.goToPage(context: context, screen: const ReceivingScreen());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GTIN Tracker v. 2.0"),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                AppImages.logo,
                width: 200,
                height: 150,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return NavigateIconWidget(
                icon: data['icon']?[index] as String,
                title: data['title']?[index] as String,
                caption: data['caption']?[index] as String,
                color: data['color']?[index] as Color,
                onTap: data['onTap']?[index] as VoidCallback,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NavigateIconWidget extends StatelessWidget {
  String icon;
  String title;
  String caption;
  Color color;
  VoidCallback onTap;

  NavigateIconWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.caption,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 120,
      child: Material(
        color: AppColors.background,
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          onTap: onTap,
          leading: Image.asset(
            icon,
            height: 100,
            fit: BoxFit.contain,
          ),
          title: AutoSizeText(
            caption,
            style: const TextStyle(fontSize: 12),
            maxLines: 3,
          ),
          subtitle: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

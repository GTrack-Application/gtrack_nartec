import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/identity/identity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data = {
    "icon": [
      AppIcons.identify,
      AppIcons.capture,
      AppIcons.share,
    ],
    "title": [
      "IDENTIFY",
      "CAPTURE",
      "SHARE",
    ],
    "caption": [
      "GTIN|GLN|SSCC|GIAI|GRAI GMN|GSRN|GSIN",
      "ASSOCIATION|TRANSFORMATION AGGREGATION|SERIALIZATION|MAPPING BARCODE AND RFID",
      "DIGITAL LINKS|PRODUCT CATALOGUE|PRODUCT CERTIFICATES|EPCIS|CBV PRODUCT ORIGIN|TRACEABILITY"
    ],
    "color": [
      AppColors.skyBlue,
      AppColors.pink,
      AppColors.green,
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
    data['onTap']?[0] = () {
      AppNavigator.goToPage(context: context, screen: const IdentityScreen());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GTIN Tracker v. 2.0"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        color: AppColors.background,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width * 0.9,
          height: context.height * 0.17,
          child: Stack(
            children: [
              ListTile(
                onTap: onTap,
                dense: true,
                leading: Image.asset(
                  icon,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: AutoSizeText(
                  caption,
                  minFontSize: 10,
                  maxFontSize: 10,
                ),
                subtitle: AutoSizeText(
                  title,
                  maxFontSize: 25,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 20,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: color),
                    image: DecorationImage(
                      image: AssetImage(icon),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

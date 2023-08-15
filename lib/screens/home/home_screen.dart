// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/capture/capture_screen.dart';
import 'package:gtrack_mobile_app/screens/home/identify/identify_screen.dart';
import 'package:gtrack_mobile_app/screens/home/share/share_screen.dart';

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
      "GTIN|GLN|SSCC|GIAI|\nGRAI GMN|GSRN|GSIN",
      "ASSOCIATION|TRANSFORMATION AGGREGATION|SERIALIZATION|MAPPING BARCODE AND RFID",
      "DIGITAL LINKS|PRODUCT CATALOGUE|PRODUCT CERTIFICATES|EPCIS|CBV\nPRODUCT ORIGIN|TRACEABILITY"
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
      AppNavigator.goToPage(context: context, screen: const IdentifyScreen());
    };
    data['onTap']?[1] = () {
      AppNavigator.goToPage(context: context, screen: const CaptureScreen());
    };
    data['onTap']?[2] = () {
      AppNavigator.goToPage(context: context, screen: const ShareScreen());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GTIN Tracker v. 2.0"),
        automaticallyImplyLeading: true,
      ),
      // make drawer from right side that contains the identity, capture and share screens
      endDrawer: const MyDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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

class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            curve: Curves.linear,
            child: Text(
              'GTIN Tracker v. 2.0',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppIcons.identify),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: const Text('Indentify'),
            onTap: () {
              Navigator.pop(context);
              AppNavigator.goToPage(
                  context: context, screen: const IdentifyScreen());
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppIcons.capture),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: const Text('Capture'),
            onTap: () {
              Navigator.pop(context);
              AppNavigator.goToPage(
                  context: context, screen: const CaptureScreen());
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppIcons.share),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              AppNavigator.goToPage(
                  context: context, screen: const ShareScreen());
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: AppColors.background,
          elevation: 7,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.background,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 60,
                  height: 60,
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
                const SizedBox(width: 20),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 70,
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            caption,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AutoSizeText(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

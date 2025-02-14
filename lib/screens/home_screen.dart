// ignore_for_file: file_names, must_be_immutable, deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/constants/app_images.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/auth/user_login_page.dart';
import 'package:gtrack_nartec/screens/home/capture/capture_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/identify_screen.dart';
import 'package:gtrack_nartec/screens/home/share/share_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  String currentUser = "";

  void getCurrentUser() {
    AppPreferences.getCurrentUser().then((value) {
      setState(() {
        currentUser = value!;
      });
    });
  }

  @override
  void initState() {
    getCurrentUser();
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
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("GTIN Tracker v.2.0"),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                AppIcons.iosLogo,
                width: 50,
                height: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                AppIcons.gs1Logo,
                width: 100,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        // Drawer from right side that contains the identity, capture and share screens
        endDrawer: MyDrawerWidget(currentUser: currentUser),

        body: SafeArea(
          child: SizedBox(
            width: context.width,
            height: context.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    AppImages.logo,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                  ),
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
          ),
        ),
      ),
    );
  }
}

class MyDrawerWidget extends StatelessWidget {
  String currentUser;

  MyDrawerWidget({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            curve: Curves.linear,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'GTIN Tracker v. 2.0',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'User Type:',
                      style: TextStyle(color: AppColors.white, fontSize: 15),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      currentUser,
                      style:
                          const TextStyle(color: AppColors.green, fontSize: 20),
                    ),
                  ],
                ),
              ],
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
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          ListTile(
            textColor: Colors.red,
            leading: SizedBox(
              width: 70,
              height: 70,
              child: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.8),
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              'Sign out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAll(() => const UserLoginPage());
            },
          ),
        ],
      ),
    );
  }
}

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

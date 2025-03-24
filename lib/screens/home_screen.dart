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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
  final String currentUser;

  const MyDrawerWidget({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      elevation: 16.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMenuItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'GTIN Tracker v. 2.0',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: AppColors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentUser,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 15),
        _buildMenuItem(
          context: context,
          icon: AppIcons.identify,
          title: 'Identify',
          screen: const IdentifyScreen(),
          iconColor: AppColors.skyBlue,
        ),
        _buildMenuItem(
          context: context,
          icon: AppIcons.capture,
          title: 'Capture',
          screen: const CaptureScreen(),
          iconColor: AppColors.pink,
        ),
        _buildMenuItem(
          context: context,
          icon: AppIcons.share,
          title: 'Share',
          screen: const ShareScreen(),
          iconColor: AppColors.green,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Divider(thickness: 1),
        ),
        _buildSignOutButton(context),
        const SizedBox(height: 20),
        // Footer with version info
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '© 2025 GTIN Tracker',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required Widget screen,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.pop(context);
            AppNavigator.goToPage(context: context, screen: screen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withOpacity(0.1),
                    border: Border.all(color: iconColor, width: 1.5),
                    image: DecorationImage(
                      image: AssetImage(icon),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: iconColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: iconColor,
                  size: 22,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Get.offAll(() => const UserLoginPage());
                    },
                    child: const Text('SIGN OUT'),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
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

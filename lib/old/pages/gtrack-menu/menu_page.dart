import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/icon_elevated_button.dart';
import 'package:gtrack_mobile_app/old/pages/gtrack-menu/dispatch_management/dispatch_management_one_page.dart';
import 'package:gtrack_mobile_app/screens/home/receiving/receiving_screen.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  static const String pageName = '/menu';

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isRawMaterial = false;

  @override
  void dispose() {
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isRawMaterial) {
          setState(() {
            isRawMaterial = false;
          });
          return false;
        } else {
          Get.back();
        }
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('GTIN Tracker'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                isRawMaterial
                    ? IconElevatedButton(
                        leadingIcon: Image.asset(AppIcons.dispatch),
                        text: "Raw Materials Issuance",
                        backgroundColor: const Color.fromRGBO(75, 0, 130, 1),
                        textColor: Colors.white,
                        onPressed: () => Get.toNamed(
                          DispatchManagementOnePage.pageName,
                        ),
                      )
                    : IconElevatedButton(
                        leadingIcon: Image.asset(AppIcons.dispatch),
                        text: "Dispatch Management",
                        backgroundColor: const Color.fromRGBO(204, 49, 49, 1),
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            isRawMaterial = true;
                          });
                        },
                      ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.receipt),
                  text: "Receipts Management",
                  backgroundColor: const Color.fromRGBO(66, 210, 132, 1),
                  textColor: Colors.white,
                  onPressed: () {
                    // Get.toNamed(ReceivingScreen.pageName);
                    AppNavigator.goToPage(
                      context: context,
                      screen: const ReceivingScreen(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.work),
                  text: "Work in Progress",
                  backgroundColor: const Color.fromRGBO(50, 174, 215, 1),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.inventory),
                  text: "Physical Inventory",
                  backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.stock),
                  text: "Stocks Management",
                  backgroundColor: const Color.fromRGBO(79, 59, 59, 1),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.barcode),
                  text: "Product Barcode Inventory",
                  backgroundColor: const Color.fromRGBO(34, 139, 34, 1),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.gtin),
                  text: "GTIN Tracking",
                  backgroundColor: const Color.fromRGBO(255, 77, 0, 1),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                IconElevatedButton(
                  leadingIcon: Image.asset(AppIcons.settings),
                  text: "Settings",
                  backgroundColor: const Color.fromRGBO(20, 15, 245, 1),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

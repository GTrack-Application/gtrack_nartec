import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/screens/home/share/Scanning/barcode_scanning_scanning.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  String? barcodeValue;
  TextEditingController barcodeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    barcodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: const Text('Scanning'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          width: context.width(),
          height: context.height(),
          child: Container(
            margin: const EdgeInsets.only(
              top: 150,
              left: 20,
              right: 20,
              bottom: 250,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              // gradient color for borders
              border: Border(
                top: BorderSide(width: 1.0, color: AppColors.green),
                left: BorderSide(width: 1.0, color: AppColors.green),
                right: BorderSide(width: 1.0, color: AppColors.green),
                bottom: BorderSide(width: 1.0, color: AppColors.green),
              ),
            ),
            child: Builder(
              builder: (context) {
                return Container(
                  alignment: Alignment.center,
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // scanBarcodeNormal();
                          AppNavigator.goToPage(
                            context: context,
                            screen: const BarcodeScanningScreen(),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/barcode_icon.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      TextWidget(
                        text: barcodeValue ?? "Scan a Barcode or QR Code",
                        fontSize: 20,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 20),
                      // TextWidget(
                      //   text: barcodeValue ?? "",
                      //   fontSize: 15,
                      //   color: AppColors.white,
                      // ),
                      // 20.height,
                      // GestureDetector(
                      //   onTap: () {
                      //     // if (barcodeController.text.length > 15 &&
                      //     //     !barcodeController.text.startsWith("01")) {
                      //     //   AppSnackbars.normal(context, "Invalid barcode");
                      //     // } else {
                      //     //   AppNavigator.goToPage(
                      //     //     context: context,
                      //     //     screen: ProductInformationScreen(
                      //     //       gtin: barcodeValue.toString(),
                      //     //     ),
                      //     //   );
                      //     // }
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 20,
                      //       vertical: 10,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         width: 1,
                      //         color: AppColors.green,
                      //       ),
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: const Text(
                      //       "View Product Information",
                      //       style: TextStyle(color: AppColors.green),
                      //     ),
                      //   ),
                      // ).visible(barcodeValue != null),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanResult;
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
      debugPrint(barcodeScanResult);
    } on PlatformException {
      barcodeScanResult = 'Failed to get platform version.';
      AppSnackbars.normal(context, barcodeScanResult);
    }
    if (!mounted) return;

    setState(() {
      barcodeValue = barcodeScanResult.replaceAll("", "");
      barcodeController.text = barcodeValue.toString();

      // Check if the barcode is 1D or 2D
      if (barcodeValue!.length < 15) {
        // It means it is 1D, no need to extract
        barcodeValue = barcodeValue;
      } else {
        barcodeValue = barcodeValue?.substring(2, 15);
      }
    });
  }
}

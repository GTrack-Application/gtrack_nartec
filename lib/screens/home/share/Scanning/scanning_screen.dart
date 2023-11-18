import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/product_information_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  String? barcodeValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: const Text('Scanning'),
        ),
        body: SizedBox(
          width: context.width(),
          height: context.height(),
          child: Container(
            margin: const EdgeInsets.only(
              top: 100,
              left: 20,
              right: 20,
              bottom: 100,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: AppColors.green.withOpacity(0.2),
              border: const Border(
                top: BorderSide(width: 1.0, color: AppColors.black),
                left: BorderSide(width: 1.0, color: AppColors.black),
                right: BorderSide(width: 1.0, color: AppColors.black),
                bottom: BorderSide(width: 1.0, color: AppColors.black),
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
                      const TextWidget(text: "Scan Barcode or QR Code"),
                      const SizedBox(height: 10),
                      AppButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        onTap: () async {
                          scanBarcodeNormal();
                        },
                        color: AppColors.green,
                        child: const Text('Scan Barcode'),
                      ),
                      const SizedBox(height: 50),
                      TextWidget(
                        text: barcodeValue ?? "No data",
                        fontSize: 15,
                      ),
                      50.height,
                      GestureDetector(
                        onTap: () {
                          AppNavigator.goToPage(
                            context: context,
                            screen: ProductInformationScreen(
                              gtin: barcodeValue.toString(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.green,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "View Product Information",
                            style: TextStyle(color: AppColors.green),
                          ),
                        ),
                      ).visible(barcodeValue != null),
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

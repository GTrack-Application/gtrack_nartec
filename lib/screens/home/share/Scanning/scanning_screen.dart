import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  String? _scanBarcodeResult;

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
                top: BorderSide(width: 1.0, color: Colors.black),
                left: BorderSide(width: 1.0, color: Colors.black),
                right: BorderSide(width: 1.0, color: Colors.black),
                bottom: BorderSide(width: 1.0, color: Colors.black),
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
                      const SizedBox(height: 10),
                      AppButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        onTap: () async {
                          scanQRCode();
                        },
                        color: AppColors.green,
                        child: const Text('Scan QR Code'),
                      ),
                      const SizedBox(height: 50),
                      TextWidget(
                        text: _scanBarcodeResult ?? "No data",
                        fontSize: 15,
                      ),
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
        ScanMode.BARCODE,
      );
      debugPrint(barcodeScanResult);
    } on PlatformException {
      barcodeScanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      barcodeScanResult = barcodeScanResult;
      _scanBarcodeResult = barcodeScanResult;
    });
  }

  Future<void> scanQRCode() async {
    String barcodeScanResult;
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      debugPrint(barcodeScanResult);
    } on PlatformException {
      barcodeScanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      barcodeScanResult = barcodeScanResult;
      _scanBarcodeResult = barcodeScanResult;
    });
  }
}

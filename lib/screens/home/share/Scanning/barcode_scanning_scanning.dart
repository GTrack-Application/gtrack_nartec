import 'package:flutter/material.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/variables/global_variable.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/product_information_screen.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';
import 'package:nb_utils/nb_utils.dart';

class BarcodeScanningScreen extends StatefulWidget {
  const BarcodeScanningScreen({super.key});

  @override
  State<BarcodeScanningScreen> createState() => _BarcodeScanningScreenState();
}

class _BarcodeScanningScreenState extends State<BarcodeScanningScreen> {
  navigate() {
    var barcodeValue = GlobalVariable.barcodeValue.text;
    var codeType = GlobalVariable.barcodeType.text;
    String? gtinCode = extractGtin(barcodeValue, codeType);

    if (gtinCode == null) {
      toast("Invalid barcode");
      return;
    }

    AppNavigator.goToPage(
      context: context,
      screen: ProductInformationScreen(
        gtin: barcodeValue.toString(),
      ),
    );
  }

  String? extractGtin(String scannedCode, String codeType) {
    if (codeType == 'ean13') {
      String cleanedBarcode = scannedCode.replaceAll(RegExp(r'[^0-9]'), '');
      return cleanedBarcode;
    } else if (codeType.toLowerCase() == 'datamatrix') {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(scannedCode);
      RegExp gtinPattern = RegExp(r'01 \(GTIN\): (\d+)');
      Match? match = gtinPattern.firstMatch(result.toString());
      if (match != null) {
        String gtin = match.group(1)!;
        return gtin;
      } else {
        return null;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BarcodeScannerWidget(
        startScanning: true,
        stopScanOnBarcodeDetected: true,
        onTextDetected: (textResult) {},
        scannerType: ScannerType.barcode,
        onBarcodeDetected: (barcode) {
          print(barcode.format.name);
          GlobalVariable.barcodeType.text = barcode.format.name;
          GlobalVariable.barcodeValue.text = barcode.value;
          navigate();
        },
        onError: (error) {
          AppSnackbars.danger(context, "Invalid barcode");
        },
      ),
    );
  }
}

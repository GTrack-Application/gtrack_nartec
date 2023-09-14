import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class GtinInformationScreen extends StatefulWidget {
  const GtinInformationScreen({super.key});

  @override
  State<GtinInformationScreen> createState() => _GtinInformationScreenState();
}

class _GtinInformationScreenState extends State<GtinInformationScreen> {
  String? _scanBarcodeResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return Container(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              child: const Text('Start Barcode Scan'),
                              onTap: () async {
                                scanBarcodeNormal();
                              },
                            ),
                            const SizedBox(width: 10),
                            AppButton(
                              child: const Text('Start QR Scan'),
                              onTap: () async {
                                scanQRCode();
                              },
                            ),

                            // text widget to display the text
                            TextWidget(text: _scanBarcodeResult ?? "No data"),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https:\/\/gs1ksa.org\/backend\/images\/products\/649809d4d08141687685588.webp'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const BorderedRowWidget(value1: "GTIN", value2: "123"),
                  const BorderedRowWidget(value1: "Brand name", value2: "123"),
                  const BorderedRowWidget(
                      value1: "Product Description", value2: "123"),
                  const BorderedRowWidget(value1: "Image URL", value2: "123"),
                  const BorderedRowWidget(
                      value1: "Global Product Category", value2: "123"),
                  const BorderedRowWidget(value1: "Net Content", value2: "123"),
                  const BorderedRowWidget(
                      value1: "Country Of Sale", value2: "123"),
                ],
              ),
            )
          ],
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

class BorderedRowWidget extends StatelessWidget {
  final String value1, value2;
  const BorderedRowWidget({
    super.key,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value1,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              value2,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

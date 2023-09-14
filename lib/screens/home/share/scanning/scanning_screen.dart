import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/screens/home/share/product-information/product_information_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({Key? key}) : super(key: key);
  static const routeName = '/scanning-screen';

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  late String cameraText;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String gtinCode = '';
  bool isStartScanning = false;

  void _onQRViewCreated(QRViewController controller) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final icon = args['icon'];
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        gtinCode = scanData.code!;
        gtinCode = gtinCode.substring(0, 13);
        if (gtinCode.isNotEmpty &&
            gtinCode.length == 13 &&
            double.tryParse(gtinCode) != null) {
          controller.pauseCamera();

          AppNavigator.goToPage(
            context: context,
            screen: const ProductInformationScreen(),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kindly scan appropriate QR Code')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  startScanning() {
    setState(() {
      isStartScanning = true;
    });
  }

  stopScanning() {
    setState(() {
      isStartScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Scan QR Code from your device's camera"
                      .text
                      .color(AppColors.primary)
                      .xl
                      .make()
                      .centered(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RectangularTextButton(
                        onPressed: stopScanning,
                        caption: "RESET",
                        buttonHeight: context.height * 0.05,
                      ),
                      RectangularTextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        caption: "PREVIOUS PAGE",
                        buttonHeight: context.height * 0.05,
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isStartScanning
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  "Ready - Click START to scan"
                      .text
                      .xl
                      .color(AppColors.primary)
                      .make()
                      .centered(),
                  20.heightBox,
                  PrimaryButtonWidget(
                    text: 'START',
                    onPressed: startScanning,
                  ).box.make().centered(),
                  const SizedBox(height: 30),
                  Text(gtinCode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RectangularTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String caption;
  final double? buttonHeight;
  const RectangularTextButton(
      {Key? key,
      required this.onPressed,
      required this.caption,
      this.buttonHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: buttonHeight ?? context.height * 0.08,
        width: context.width * 0.36,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey,
        ),
        child: Center(
          child: AutoSizeText(
            caption,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

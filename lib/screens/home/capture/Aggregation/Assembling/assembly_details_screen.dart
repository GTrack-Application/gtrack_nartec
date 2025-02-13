import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class AssemblyDetailsScreen extends StatefulWidget {
  const AssemblyDetailsScreen({super.key, required this.employees});

  final ProductsModel employees;

  @override
  State<AssemblyDetailsScreen> createState() => _AssemblyDetailsScreenState();
}

class _AssemblyDetailsScreenState extends State<AssemblyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.pink,
                    AppColors.pink.withOpacity(0.5),
                    Colors.pinkAccent.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                // gradient color
                color: AppColors.pink,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Product Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.employees.id!,
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2, // Set the border width
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${AppUrls.baseUrlWith3093}${widget.employees.frontImage?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_outlined),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("QR Code",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: PrettyQrView.data(
                          data: widget.employees.barcode ?? "null",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width * 0.98,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  KeyValueInfoWidget(
                    keyy: 'Name English',
                    value: widget.employees.productnameenglish ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Name Arabic',
                    value: widget.employees.productnamearabic ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Brand Eng',
                    value: widget.employees.brandName ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Brand Arabic',
                    value: widget.employees.brandNameAr ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Barcode',
                    value: widget.employees.barcode ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'URL',
                    value: widget.employees.productUrl ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Product Type',
                    value: widget.employees.productType ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Origin',
                    value: widget.employees.origin ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Package Type',
                    value: widget.employees.packagingType ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Unit',
                    value: widget.employees.unit ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Size Type',
                    value: widget.employees.size ?? "null",
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  // rgba(249, 75, 0, 1)
                  backgroundColor: const Color.fromRGBO(249, 75, 0, 1),
                ),
                child: const Text(
                  'Print Barcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyValueInfoWidget extends StatelessWidget {
  const KeyValueInfoWidget({
    super.key,
    required this.keyy,
    required this.value,
  });

  final String keyy;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(2),
              color: AppColors.primary,
              child: Text(
                keyy,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(right: 10),
              color: Colors.grey.withOpacity(0.4),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

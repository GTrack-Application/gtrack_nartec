import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/features/identify/models/IDENTIFY/GTIN/GTINModel.dart';

class GtinProductCard extends StatelessWidget {
  final GTIN_Model product;
  final Function()? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const GtinProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = product.gepirPosted == "1";
    return Card(
      color: backgroundColor ?? AppColors.background,
      // margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor ?? AppColors.background),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Actions Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              spacing: 12,
              children: [
                Text(
                  isVerified ? 'Verified' : 'Un-Verified',
                  style: TextStyle(
                    color: isVerified ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // QR Code
                GestureDetector(
                  onTap: onTap,
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=50x50&data=${product.barcode}',
                    width: 32,
                    height: 32,
                  ),
                ),
                // Barcode
                SizedBox(
                  height: 32,
                  width: 100,
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: product.barcode ?? '',
                    drawText: false,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.skyBlue, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        isVerified ? AppColors.green : AppColors.danger,
                    child: Icon(
                      isVerified ? Icons.check : Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              if (product.frontImage != null)
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: CachedNetworkImage(
                    imageUrl: '${AppUrls.gs1Url}${product.frontImage}',
                    fit: BoxFit.contain,
                    errorWidget: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                    ),
                  ),
                ),
              // Product Information
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              'GTIN: ${product.barcode ?? ""}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Brand Name:', product.brandName),
                            _buildInfoRow('Product Description:',
                                product.productnameenglish),
                            _buildInfoRow('GPC:', product.gpc),
                            _buildInfoRow('Country of Origin:', product.origin),
                            _buildInfoRow(
                                'Country of Sale:', product.countrySale),
                            _buildInfoRow('Net Content:',
                                '${product.size} ${product.unit}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'N/A',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Icon(
                  value != null ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: value != null ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/sales_order_scan_asset_screen.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/job_order_bom_start_screen1.dart';

class JobOrderBomDetailsScreen extends StatefulWidget {
  final String barcode;
  final bool? isSalesOrder;

  const JobOrderBomDetailsScreen({
    super.key,
    required this.barcode,
    this.isSalesOrder = false,
  });

  @override
  State<JobOrderBomDetailsScreen> createState() =>
      _JobOrderBomDetailsScreenState();
}

class _JobOrderBomDetailsScreenState extends State<JobOrderBomDetailsScreen> {
  late ProductionJobOrderCubit _productionJobOrderCubit;
  @override
  void initState() {
    super.initState();
    _productionJobOrderCubit = ProductionJobOrderCubit();
    _productionJobOrderCubit.getBomStartDetails(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.pink,
        elevation: 0,
      ),
      body: BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
        bloc: _productionJobOrderCubit,
        builder: (context, state) {
          if (state is ProductionJobOrderBomStartLoading) {
            return _buildShimmer();
          }

          if (state is ProductionJobOrderBomStartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 60, color: AppColors.pink.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButtonWidget(
                    onPressed: () {
                      final product = _productionJobOrderCubit.gs1Data;
                      if (widget.isSalesOrder == true) {
                        AppNavigator.goToPage(
                          context: context,
                          screen: SalesOrderScanAssetScreen(
                            barcode: widget.barcode,
                            bomStartData: product,
                            isSalesOrder: widget.isSalesOrder,
                          ),
                        );
                      } else {
                        AppNavigator.goToPage(
                          context: context,
                          screen: JobOrderBomStartScreen1(
                            gtin: widget.barcode,
                            productName: product.productnameenglish ?? '',
                            isSalesOrder: widget.isSalesOrder,
                          ),
                        );
                      }
                    },
                    text: "Start Picking",
                    height: 30,
                    width: 150,
                    backgroundColor: AppColors.pink,
                  ),
                ],
              ),
            );
          }

          if (state is ProductionJobOrderBomStartLoaded) {
            final product = state.bomStartData;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product.frontImage),
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Product Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.inventory_2, 'Name (English)',
                              product.productnameenglish ?? 'N/A'),
                          _buildInfoRow(Icons.translate, 'Name (Arabic)',
                              product.productnamearabic ?? 'N/A'),
                          _buildInfoRow(Icons.branding_watermark, 'Brand',
                              product.brandName ?? 'N/A'),
                          _buildInfoRow(Icons.category, 'Type',
                              product.productType ?? 'N/A'),
                          _buildInfoRow(
                              Icons.public, 'Origin', product.origin ?? 'N/A'),
                          _buildInfoRow(Icons.inventory, 'Packaging',
                              product.packagingType ?? 'N/A'),
                          _buildInfoRow(
                              Icons.straighten, 'Unit', product.unit ?? 'N/A'),
                          _buildInfoRow(Icons.aspect_ratio, 'Size',
                              product.size ?? 'N/A'),
                          _buildInfoRow(Icons.qr_code, 'Barcode',
                              product.barcode ?? 'N/A'),
                          _buildInfoRow(Icons.category_outlined, 'GPC',
                              product.gpc ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      PrimaryButtonWidget(
                        onPressed: () {
                          if (widget.isSalesOrder == true) {
                            AppNavigator.goToPage(
                              context: context,
                              screen: SalesOrderScanAssetScreen(
                                barcode: widget.barcode,
                                bomStartData: product,
                                isSalesOrder: widget.isSalesOrder,
                              ),
                            );
                          } else {
                            AppNavigator.goToPage(
                              context: context,
                              screen: JobOrderBomStartScreen1(
                                gtin: widget.barcode,
                                productName: product.productnameenglish ?? '',
                                isSalesOrder: widget.isSalesOrder,
                              ),
                            );
                          }
                        },
                        text: "Start Picking",
                        height: 40,
                        width: 150,
                        backgroundColor: AppColors.pink,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return GestureDetector(
      onTap: () {
        if (imageUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Container(
                  color: Colors.black,
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: CachedNetworkImage(
                        imageUrl: '${AppUrls.domain}$imageUrl',
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: '${AppUrls.domain}$imageUrl',
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                )
              : Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: AppColors.grey.withValues(alpha: 0.5),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: AppColors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    10,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: double.infinity,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

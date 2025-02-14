import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class JobOrderBomStartScreen extends StatefulWidget {
  final String barcode;
  final String jobOrderNumber;

  const JobOrderBomStartScreen({
    super.key,
    required this.barcode,
    required this.jobOrderNumber,
  });

  @override
  State<JobOrderBomStartScreen> createState() => _JobOrderBomStartScreenState();
}

class _JobOrderBomStartScreenState extends State<JobOrderBomStartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductionJobOrderCubit>().getBomStartDetails(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details - ${widget.jobOrderNumber}'),
        backgroundColor: AppColors.pink,
      ),
      body: BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
        builder: (context, state) {
          if (state is ProductionJobOrderBomStartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductionJobOrderBomStartError) {
            return Center(child: Text(state.message));
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
                  _buildInfoCard(
                    title: 'Product Information',
                    children: [
                      _buildInfoRow('Name (English)',
                          product.productnameenglish ?? 'N/A'),
                      _buildInfoRow(
                          'Name (Arabic)', product.productnamearabic ?? 'N/A'),
                      _buildInfoRow('Brand', product.brandName ?? 'N/A'),
                      _buildInfoRow('Type', product.productType ?? 'N/A'),
                      _buildInfoRow('Origin', product.origin ?? 'N/A'),
                      _buildInfoRow(
                          'Packaging', product.packagingType ?? 'N/A'),
                      _buildInfoRow('Unit', product.unit ?? 'N/A'),
                      _buildInfoRow('Size', product.size ?? 'N/A'),
                      _buildInfoRow('Barcode', product.barcode ?? 'N/A'),
                      _buildInfoRow('GPC', product.gpc ?? 'N/A'),
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
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.background),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: '${AppUrls.domain}$imageUrl',
              fit: BoxFit.contain,
              errorWidget: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 50),
            )
          : const Icon(Icons.image_not_supported, size: 50),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

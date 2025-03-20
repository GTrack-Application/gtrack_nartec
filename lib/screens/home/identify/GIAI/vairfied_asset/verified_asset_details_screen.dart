import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import '../model/varified_asset_model.dart';

class VerifiedAssetDetailsScreen extends StatefulWidget {
  const VerifiedAssetDetailsScreen({
    super.key,
    required this.asset,
    required this.heroIndex,
  });

  final VarifiedAssetModel asset;
  final int heroIndex;

  @override
  State<VerifiedAssetDetailsScreen> createState() =>
      _VerifiedAssetDetailsScreenState();
}

class _VerifiedAssetDetailsScreenState
    extends State<VerifiedAssetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Asset Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.asset.tagNumber ?? 'No Tag Number',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.asset.aSSETdESCRIPTION ?? 'No Description',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Hero(
                      tag:
                          'qr_code_${widget.asset.tagNumber}_${widget.heroIndex}',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 80,
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: widget.asset.tagNumber ?? '',
                            backgroundColor: Colors.white,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 10),

            // Asset Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.asset.assettYPE ?? 'N/A',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Asset Images
            if (widget.asset.images != null && widget.asset.images!.isNotEmpty)
              _buildImageGallery(),

            const SizedBox(height: 20),

            // Asset Details Section
            const Text(
              'Asset Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Asset Description', widget.asset.aSSETdESCRIPTION),
            _buildDetailRow('Serial Number', widget.asset.sERIALnUMBER),
            _buildDetailRow('Major Category', widget.asset.majorCategory),
            _buildDetailRow(
                'Minor Category', widget.asset.minorCategoryDescription),
            _buildDetailRow('Condition', widget.asset.aSSETcONDITION),
            _buildDetailRow('Manufacturer', widget.asset.manufacturer),
            _buildDetailRow('Model', widget.asset.modelofAsset),

            const SizedBox(height: 20),

            // Location Details Section
            const Text(
              'Location Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Location', widget.asset.fullLocationDetails),
            _buildDetailRow('Building',
                '${widget.asset.buildingName} (${widget.asset.bUILDINGNO})'),
            _buildDetailRow('Floor', widget.asset.fLOORNO),
            _buildDetailRow('Business Unit', widget.asset.businessUnit),

            const SizedBox(height: 20),

            // Timeline Section
            const Text(
              'Asset Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stepper(
              type: StepperType.vertical,
              currentStep: 0,
              controlsBuilder: (context, controls) {
                return const SizedBox.shrink();
              },
              steps: [
                Step(
                  title: const Text(
                    'Asset Verified',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'The asset has been verified and added to the system',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: true,
                  state: StepState.complete,
                ),
                Step(
                  title: const Text(
                    'Asset Registered',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Asset has been registered in the system with all details',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: false,
                  state: StepState.disabled,
                ),
                Step(
                  title: const Text(
                    'Asset Created',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Asset has been initially created in the system',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  isActive: false,
                  state: StepState.disabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Asset Images',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.asset.images!.length,
            itemBuilder: (context, index) {
              final image = widget.asset.images![index];
              final formattedPath = image.path
                      ?.replaceAll(RegExp(r'^/+'), '')
                      .replaceAll("\\", "/") ??
                  '';
              final imageUrl = "${AppUrls.baseUrlWith7010}/$formattedPath";

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

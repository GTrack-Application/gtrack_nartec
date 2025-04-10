// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../cubit/fats_cubit.dart';
import '../cubit/fats_state.dart';
import '../model/varified_asset_model.dart';
import 'verified_asset_details_screen.dart';

class VerifiedAssetScreen extends StatefulWidget {
  const VerifiedAssetScreen({super.key});

  @override
  State<VerifiedAssetScreen> createState() => _VerifiedAssetScreenState();
}

class _VerifiedAssetScreenState extends State<VerifiedAssetScreen> {
  final FatsCubit cubit = FatsCubit();
  final TextEditingController _searchController = TextEditingController();
  List<VarifiedAssetModel> _filteredAssets = [];

  String? gs1Prefix;

  getGs1Prefix() async {
    gs1Prefix = await AppPreferences.getGs1Prefix();
  }

  void _filterAssets(List<VarifiedAssetModel> assets, String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAssets = assets;
      } else {
        _filteredAssets = assets.where((asset) {
          final tagNumber = asset.tagNumber?.toLowerCase() ?? '';
          final description = asset.aSSETdESCRIPTION?.toLowerCase() ?? '';
          final serialNumber = asset.sERIALnUMBER?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return tagNumber.contains(searchLower) ||
              description.contains(searchLower) ||
              serialNumber.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cubit.getVerifiedAsset();
    getGs1Prefix();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Verified Assets'),
      ),
      body: BlocBuilder<FatsCubit, FatsState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is VerifiedAssetLoading) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar placeholder
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List placeholder
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => const LoadingAssetCard(),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is VerifiedAssetError) {
            return Center(child: Text(state.message));
          } else if (state is VerifiedAssetLoaded) {
            // Initialize filtered assets if empty
            if (_filteredAssets.isEmpty) {
              _filteredAssets = state.data;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search assets...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterAssets(state.data, '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => _filterAssets(state.data, value),
                  ),
                  const SizedBox(height: 16),
                  // List of assets
                  Expanded(
                    child: _filteredAssets.isEmpty
                        ? const Center(
                            child: Text('No matching assets found'),
                          )
                        : ListView.builder(
                            itemCount: _filteredAssets.length,
                            itemBuilder: (context, index) {
                              final asset = _filteredAssets[index];
                              return AssetCard(
                                asset: asset,
                                index: index,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No assets found'));
        },
      ),
    );
  }
}

class AssetCard extends StatelessWidget {
  final VarifiedAssetModel asset;
  final int index;

  const AssetCard({
    super.key,
    required this.asset,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final gs1Prefix = context
            .findAncestorStateOfType<_VerifiedAssetScreenState>()
            ?.gs1Prefix ??
        '';
    final barcode = '$gs1Prefix${asset.tagNumber ?? ''}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifiedAssetDetailsScreen(
              asset: asset,
              heroIndex: index,
            ),
          ),
        );
      },
      child: Card(
        color: AppColors.white,
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(barcode, context),
              const Divider(height: 16),
              _buildAssetDetails(),
              if (asset.images != null && asset.images!.isNotEmpty)
                _buildImageSection(),
              const Divider(height: 16),
              _buildLocationDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String barcode, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                barcode,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                asset.tagNumber ?? 'No Tag Number',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                asset.aSSETdESCRIPTION ?? 'No Description',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  asset.assettYPE ?? 'N/A',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Hero(
                tag: 'qr_code_${asset.tagNumber}_$index',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: barcode == null ||
                              barcode.isEmpty ||
                              barcode == "null"
                          ? "null"
                          : barcode,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Serial Number', asset.sERIALnUMBER),
        _buildDetailRow('Category',
            '${asset.majorCategory} - ${asset.minorCategoryDescription}'),
        _buildDetailRow('Condition', asset.aSSETcONDITION),
        _buildDetailRow('Manufacturer', asset.manufacturer),
        _buildDetailRow('Model', asset.modelofAsset),
      ],
    );
  }

  Widget _buildImageSection() {
    final displayImages = asset.images!.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Asset Images',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayImages.length,
            itemBuilder: (context, index) {
              final image = displayImages[index];
              final formattedPath = image.path
                      ?.replaceAll(RegExp(r'^/+'), '')
                      .replaceAll("\\", "/") ??
                  '';
              final imageUrl = "${AppUrls.baseUrlWith7010}/$formattedPath";

              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
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

  Widget _buildLocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Location', asset.fullLocationDetails),
        _buildDetailRow(
            'Building', '${asset.buildingName} (${asset.bUILDINGNO})'),
        _buildDetailRow('Floor', asset.fLOORNO),
        _buildDetailRow('Business Unit', asset.businessUnit),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingAssetCard extends StatelessWidget {
  const LoadingAssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 180,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            Column(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 16,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 16),
            Container(
              width: 100,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[300],
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

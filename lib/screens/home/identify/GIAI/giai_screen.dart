// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/identify/GIAI/giai_cubit.dart';
import 'package:gtrack_nartec/cubit/identify/GIAI/giai_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/asset_capture_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/asset_verification_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/generate_tags_screen.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/giai_details_screen.dart';

class GIAIScreen extends StatefulWidget {
  const GIAIScreen({super.key});

  @override
  State<GIAIScreen> createState() => _GIAIScreenState();
}

class _GIAIScreenState extends State<GIAIScreen> {
  final GIAICubit giaiCubit = GIAICubit();

  @override
  void initState() {
    super.initState();
    giaiCubit.getGIAI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Un-Verified Assets'),
      ),
      body: BlocConsumer<GIAICubit, GIAIState>(
        bloc: giaiCubit,
        listener: (context, state) {
          if (state is GIAIGetGIAISuccess) {
            if (kDebugMode) {
              print(state.giai);
            }
          }
          if (state is GIAIGetGIAIError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
          if (state is GIAIDeleteGIAISuccess) {
            giaiCubit.getGIAI();
          }
          if (state is GIAIDeleteGIAIError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is GIAIDeleteGIAILoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deleting...'),
                backgroundColor: AppColors.danger,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search assets...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.visibility, 'Asset\nCapture',
                          () {
                        AppNavigator.goToPage(
                            context: context, screen: AssetCaptureScreen());
                      }),
                      _buildActionButton(Icons.upload, 'Generate\nGIAI Tag',
                          () {
                        AppNavigator.goToPage(
                            context: context, screen: GenerateTagsScreen());
                      }),
                      _buildActionButton(Icons.refresh, 'Asset\nVerification',
                          () {
                        AppNavigator.goToPage(
                            context: context,
                            screen: AssetVerificationScreen());
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Asset cards
                state is GIAIGetGIAISuccess
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.giai.length,
                          itemBuilder: (context, index) {
                            return _buildAssetCard(
                              state.giai[index].id ?? '',
                              state.giai[index].tagNumber ?? '',
                              state.giai[index].assetDescription ?? '',
                              state.giai[index].assetType ?? '',
                              state.giai[index].daoName ?? '',
                              state.giai[index].majorCategory ?? '',
                              _formatDateTime(
                                  state.giai[index].createdAt ?? ""),
                              _formatDateTime(
                                  state.giai[index].updatedAt ?? ''),
                              state.giai[index].tagNumber?.isNotEmpty ?? false,
                              () {
                                giaiCubit
                                    .deleteGIAI(state.giai[index].id ?? '');
                              },
                              () {
                                AppNavigator.goToPage(
                                  context: context,
                                  screen: GIAIDetailsScreen(
                                    giai: state.giai[index],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3, // Show 3 placeholder cards
                          itemBuilder: (context, index) {
                            return Card(
                              color: AppColors.white,
                              elevation: 4,
                              child: Container(
                                height: 150,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 12,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 200,
                                      height: 14,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.23,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: AppColors.skyBlue.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.skyBlue,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(
    String id,
    String tagNumber,
    String assetDescription,
    String assetType,
    String area,
    String majorCategory,
    String created,
    String lastMaintenance,
    bool isCompleted,
    Function()? onDelete,
    Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Created: $created",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isCompleted
                        ? const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
              Text(
                tagNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Separate the barcode into its own Hero widget
              SizedBox(
                // Wrap with SizedBox for better control
                width: MediaQuery.of(context).size.width * 0.5,
                child: Hero(
                  tag: "barcode_${tagNumber}",
                  child: Material(
                    // Add Material widget to preserve the widget tree
                    color: Colors.transparent,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: tagNumber == null ||
                              tagNumber.isEmpty ||
                              tagNumber == "null"
                          ? ""
                          : tagNumber,
                      color: Colors.black,
                      height: 60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Area:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          area, // Replace with actual area
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Asset type:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          assetType, // Replace with actual asset type
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Major Category:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          majorCategory, // Replace with actual category
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}

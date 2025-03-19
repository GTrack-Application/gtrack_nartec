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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.visibility, 'Asset\nCapture', () {
                      AppNavigator.goToPage(
                          context: context, screen: AssetCaptureScreen());
                    }),
                    _buildActionButton(Icons.upload, 'Generate\nGIAI Tag', () {
                      AppNavigator.goToPage(
                          context: context, screen: GenerateTagsScreen());
                    }),
                    _buildActionButton(Icons.refresh, 'Asset\nVerification',
                        () {
                      AppNavigator.goToPage(
                          context: context, screen: AssetVerificationScreen());
                    }),
                  ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(
    String id,
    String tagNumber,
    String assetDescription,
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
                      fontSize: 14,
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
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tagNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Barcode image would go here - you'll need to implement barcode generation
              Align(
                alignment: Alignment.centerLeft,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: tagNumber,
                  color: Colors.black,
                  width: 200,
                  height: 60,
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
                          "HR", // Replace with actual area
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
                          "CNC", // Replace with actual asset type
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
                          "9", // Replace with actual category
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

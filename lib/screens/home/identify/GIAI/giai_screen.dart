// ignore_for_file: unnecessary_brace_in_string_interps

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
    String name,
    String status,
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
                    "Created Date: ${created}",
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 10,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Pending',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                id,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Maintainance Date:\n${lastMaintenance}",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
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

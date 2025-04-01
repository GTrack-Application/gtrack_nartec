import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/features/capture/cubits/agregation/packaging/packaging_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packaging/packaging_master_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/packaging/packaging_type_screen.dart';
import 'package:intl/intl.dart';

class PackagingScreen extends StatefulWidget {
  const PackagingScreen({super.key});

  @override
  State<PackagingScreen> createState() => _PackagingScreenState();
}

class _PackagingScreenState extends State<PackagingScreen> {
  final ScrollController _scrollController = ScrollController();
  late PackagingCubit packagingCubit;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    packagingCubit = PackagingCubit();
    packagingCubit.getPackagingMasters();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (packagingCubit.hasMoreData) {
        packagingCubit.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packaging'),
        backgroundColor: AppColors.pink,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showPalletTypeDialog();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.print, color: AppColors.white),
                        SizedBox(width: 4),
                        Text(
                          "Packaging Box",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PackagingCubit, PackagingState>(
              bloc: packagingCubit,
              builder: (context, state) {
                if (state is PackagingMasterLoading) {
                  return _buildShimmer();
                }

                if (packagingCubit.packagingMasters.isEmpty) {
                  return Center(child: Text('No data found'));
                }

                if (state is PackagingMasterError) {
                  return Center(child: Text(state.message));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8),
                  itemCount: packagingCubit.packagingMasters.length + 1,
                  itemBuilder: (context, index) {
                    if (index == packagingCubit.packagingMasters.length) {
                      return (state is PackagingLoadingMoreState &&
                              packagingCubit.hasMoreData)
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.pink,
                                strokeWidth: 2,
                              ),
                            )
                          : !packagingCubit.hasMoreData
                              ? SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: Text(packagingCubit
                                        .packagingMasters.length
                                        .toString()),
                                  ),
                                )
                              : SizedBox.shrink();
                    }

                    final package = packagingCubit.packagingMasters[index];
                    return PackagingCard(package: package);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  showPalletTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Packaing Box'),
        backgroundColor: AppColors.background,
        children: [
          // create a wrap widget of 3 columns and 5 elements total
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                buildPackingBox(
                  title: "Pallet",
                  slug: 'pallet',
                  icon: AppIcons.pallet,
                ),
                buildPackingBox(
                  title: "Box/Carton",
                  slug: 'box',
                  icon: AppIcons.boxcarton,
                ),
                buildPackingBox(
                  title: "Bundle",
                  slug: 'bundle',
                  icon: AppIcons.bundle,
                ),
                buildPackingBox(
                  title: "Pack",
                  slug: 'pack',
                  icon: AppIcons.pack,
                ),
                buildPackingBox(
                  title: "Piece",
                  slug: 'piece',
                  icon: AppIcons.piece,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPackingBox({
    required String title,
    required String slug,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        AppNavigator.goToPage(
          context: context,
          screen: PackagingTypeScreen(type: title, slug: slug),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.pink),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: AppColors.pink,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          spacing: 4.0,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.background,
              child: Image.asset(icon, height: 60, width: 60),
            ),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(color: AppColors.black, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 120,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Spacer(),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class PackagingCard extends StatelessWidget {
  final PackagingMasterModel package;

  const PackagingCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SSCC: ${package.ssccNo}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pallets: ${package.totalPallet}',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Transaction Date: ${DateFormat('dd/MM/yyyy HH:mm').format(package.transactionDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Created At: ${DateFormat('dd/MM/yyyy HH:mm').format(package.createdAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

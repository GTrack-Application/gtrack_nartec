// ignore_for_file: collection_methods_unrelated_type

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packed_items/packed_items_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/models/Identify/GLN/GLNProductsModel.dart';
import 'package:gtrack_nartec/models/capture/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/packing/complete_packing_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/packing/packing_details_screen.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({super.key});

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  TextEditingController searchController = TextEditingController();

  GlnCubit glnCubit = GlnCubit();
  List<GLNProductsModel> table = [];

  List<String> dropdownList = [];
  String? dropdownValue;

  List<String> gln = [];

  @override
  void initState() {
    super.initState();
    glnCubit.identifyGln();
  }

  PackedItemsCubit packedItemsCubit = PackedItemsCubit();
  List<PackedItemsModel> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Packing'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<GlnCubit, GlnState>(
          bloc: glnCubit,
          listener: (context, state) {
            if (state is GlnErrorState) {
              AppSnackbars.danger(context, state.message);
            }
            if (state is GlnLoadedState) {
              table = state.data;
              dropdownList = table.map((e) => e.locationNameAr ?? "").toList();
              gln = table.map((e) => e.gcpGLNID ?? "").toList();
              dropdownList = dropdownList.toSet().toList();
              dropdownValue = dropdownList[0];
              packedItemsCubit
                  .getPackedItems(gln[dropdownList.indexOf(dropdownValue!)]);
            }
          },
          builder: (context, state) {
            if (state is GlnLoadingState) {
              return buildPlaceholder();
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.fromBorderSide(
                              BorderSide(color: AppColors.grey)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            isExpanded: true,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                              packedItemsCubit.getPackedItems(
                                  gln[dropdownList.indexOf(newValue!)]);
                            },
                            items: dropdownList
                                .map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 40,
                        decoration:
                            const BoxDecoration(color: AppColors.primary),
                        child: const Text(
                          'List of Pack Items',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              BlocConsumer<PackedItemsCubit, PackedItemsState>(
                            bloc: packedItemsCubit,
                            listener: (context, state) {
                              if (state is PackedItemsError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              if (state is PackedItemsLoaded) {
                                products = state.data;
                              }
                            },
                            builder: (context, state) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  packedItemsCubit.getPackedItems(
                                    gln[dropdownList.indexOf(dropdownValue!)],
                                  );
                                },
                                child: ListView.builder(
                                  itemCount: products.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2)),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                          products[index].itemName ?? "",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          products[index].gTIN ?? "",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        leading: Hero(
                                          tag: products[index].id ?? "",
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${AppUrls.baseUrlWith3093}${products[index].itemImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                          Icons.image_outlined),
                                            ),
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            AppNavigator.goToPage(
                                              context: context,
                                              screen: PackingDetailsScreen(
                                                employees: products[index],
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                              "assets/icons/view.png"),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              AppNavigator.goToPage(
                                context: context,
                                screen: const CompletePackingScreen(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(249, 75, 0, 1),
                            ),
                            child: const Text(
                              'Start Packing',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: state is GlnLoadingState,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header placeholder
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 24),
          ),

          // Location info placeholder
          _buildLoadingSection(
            title: 'Location Information',
            items: 3,
          ),

          const SizedBox(height: 24),

          // Scanning info placeholder
          _buildLoadingSection(
            title: 'Scanning Details',
            items: 2,
          ),

          const SizedBox(height: 24),

          // Button placeholder
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.pink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build loading section
  Widget _buildLoadingSection({required String title, required int items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Container(
          width: 150,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.skyBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.only(bottom: 16),
        ),

        // Loading items
        ...List.generate(
          items,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                // Text placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
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
      ],
    );
  }
}

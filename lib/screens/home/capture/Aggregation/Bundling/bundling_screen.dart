// ignore_for_file: collection_methods_unrelated_type

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/assembling_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/assembling_state.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_state.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Bundling/created_bundle_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Bundling/gtin_details_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class BundlingScreen extends StatefulWidget {
  const BundlingScreen({super.key});

  @override
  State<BundlingScreen> createState() => _BundlingScreenState();
}

class _BundlingScreenState extends State<BundlingScreen> {
  TextEditingController searchController = TextEditingController();

  CreateBundleCubit createBundleCubit = CreateBundleCubit();

  AssemblingCubit assembleCubit = AssemblingCubit();
  List<ProductsModel> products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bundling'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<AssemblingCubit, AssemblingState>(
          bloc: assembleCubit,
          listener: (context, state) {
            if (state is AssemblingError) {
              toast(state.message);
            }
            if (state is BundlingLoaded) {
              FocusNode().unfocus();
              searchController.clear();
              products.addAll(state.bundlings);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              assembleCubit.getBundlingProductsByGtin(
                                  searchController.text.trim());
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(left: 10, top: 5),
                              hintText: 'Scan GTIN',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      5.width,
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            assembleCubit.getBundlingProductsByGtin(
                                searchController.text.trim());
                          },
                          child: SizedBox(
                            height: 30,
                            child: Image.asset(
                              'assets/icons/qr_code.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: context.width() * 1,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: const Text(
                      'List of Products',
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
                      child: state is AssemblingLoading
                          ? ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: context.width() * 0.9,
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
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.2)),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      title: Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      subtitle: Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: products.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: context.width() * 0.9,
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
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Text(
                                      products[index].productnameenglish ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      products[index].barcode ?? "",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    leading: Hero(
                                      tag: products[index].id ?? "",
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${AppUrls.baseUrlWith3093}${products[index].frontImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        AppNavigator.goToPage(
                                          context: context,
                                          screen: GTINDetailsScreen(
                                            employees: products[index],
                                          ),
                                        );
                                      },
                                      child:
                                          Image.asset("assets/icons/view.png"),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  products.isEmpty
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            BlocConsumer<CreateBundleCubit, CreateBundleState>(
                              bloc: createBundleCubit,
                              listener: (context, state) {
                                if (state is CreateBundleError) {
                                  toast(state.message);
                                }
                                if (state is CreateBundleLoaded) {
                                  setState(() {
                                    searchController.clear();
                                    products = [];
                                  });
                                  toast("Bundle Created Successfully");
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: const CreatedBundleScreen(),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    createBundleCubit.createBundle(products
                                        .map((e) => e.barcode!)
                                        .toList());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(249, 75, 0, 1),
                                  ),
                                  child: state is CreateBundleLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white)))
                                      : const Text(
                                          'Create Bundle',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                );
                              },
                            ),
                            Text("Total Of GTIN: ${products.length}"),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

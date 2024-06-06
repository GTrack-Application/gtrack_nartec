// ignore_for_file: collection_methods_unrelated_type

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/assembling_state.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_bundle_by_userId/bundle_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_bundle_by_userId/bundle_state.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Bundling/gtin_details_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class CreatedBundleScreen extends StatefulWidget {
  const CreatedBundleScreen({super.key});

  @override
  State<CreatedBundleScreen> createState() => _CreatedBundleScreenState();
}

class _CreatedBundleScreenState extends State<CreatedBundleScreen> {
  TextEditingController searchController = TextEditingController();

  CreateBundleCubit createBundleCubit = CreateBundleCubit();

  BundleCubit bundleCubit = BundleCubit();
  List<ProductsModel> products = [];

  @override
  void initState() {
    super.initState();
    bundleCubit.getBundleByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // change the back button color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Created Bundles'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<BundleCubit, BundleState>(
          bloc: bundleCubit,
          listener: (context, state) {
            if (state is BundleError) {
              toast(state.message);
            }
            if (state is BundleLoaded) {
              FocusNode().unfocus();
              searchController.clear();
              products.addAll(state.products);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: context.width() * 1,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: Text(
                      'List of Created Bundle Products (${products.length})',
                      style: const TextStyle(
                        fontSize: 15,
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
                                      horizontal: 20, vertical: 10),
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
                                          imageUrl: products[index]
                                                      .frontImage ==
                                                  null
                                              ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                              : "${AppUrls.baseUrlWith3093}${products[index].frontImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.image_outlined),
                                        ),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        AppNavigator.goToPage(
                                            context: context,
                                            screen: GTINDetailsScreen(
                                                employees: products[index]));
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

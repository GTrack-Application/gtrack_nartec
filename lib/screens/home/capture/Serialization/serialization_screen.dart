// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/capture/Serialization/serialization_details_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Serialization/serialization_gtin_screen.dart';

class SerializationScreen extends StatefulWidget {
  const SerializationScreen({super.key});

  @override
  State<SerializationScreen> createState() => _SerializationScreenState();
}

class _SerializationScreenState extends State<SerializationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serialization"),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            SizedBox(height: 10),
            _buildSerializationList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              controller: CaptureCubit.get(context).gtin,
              onEditingComplete: () {
                CaptureCubit.get(context).getGtinProducts();
              },
              decoration: InputDecoration(
                hintText: 'Enter GTIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: AppColors.pink,
          foregroundColor: AppColors.white,
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              CaptureCubit.get(context).getGtinProducts();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSerializationList(BuildContext context) {
    return Expanded(
      flex: 4,
      child:
          BlocConsumer<CaptureCubit, CaptureState>(listener: (context, state) {
        if (state is CaptureGetGtinProductsSuccess) {
          CaptureCubit.get(context).gtinProducts.addAll(state.data);
        }
        if (state is CaptureGetGtinProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }, builder: (context, state) {
        if (state is CaptureGetGtinProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            CaptureCubit.get(context).gtinProducts.clear();
            CaptureCubit.get(context).getGtinProducts();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  width: double.infinity,
                  color: AppColors.pink,
                  child: const Text(
                    "List of GTIN",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
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
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: () {
                          // AppNavigator.goToPage(
                          //   context: context,
                          //   screen: SerializationGtinScreen(
                          //     gtinModel:
                          //         CaptureCubit.get(context).gtinProducts[index],
                          //   ),
                          // );
                        },
                        title: Text(
                          CaptureCubit.get(context)
                              .gtinProducts[index]
                              .SerialNo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          CaptureCubit.get(context)
                              .gtinProducts[index]
                              .EXPIRY_DATE
                              .toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                        // leading: Hero(
                        //   tag: CaptureCubit.get(context)
                        //           .gtinProducts[index]
                        //           .GTIN ??
                        //       "",
                        //   child: ClipOval(
                        //     child: CachedNetworkImage(
                        //       imageUrl:
                        //           "${AppUrls.baseUrlWith3093}${CaptureCubit.get(context).gtinProducts[index].frontImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
                        //       width: 50,
                        //       height: 50,
                        //       fit: BoxFit.cover,
                        //       errorWidget: (context, url, error) =>
                        //           const Icon(Icons.image_outlined),
                        //     ),
                        //   ),
                        // ),
                        trailing: GestureDetector(
                          onTap: () {
                            // AppNavigator.goToPage(
                            //   context: context,
                            //   screen: SerializationDetailsScreen(
                            //     employees: CaptureCubit.get(context)
                            //         .gtinProducts[index],
                            //   ),
                            // );
                          },
                          child: Image.asset("assets/icons/view.png"),
                        ),
                      ),
                    ),
                    itemCount: CaptureCubit.get(context).gtinProducts.length,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

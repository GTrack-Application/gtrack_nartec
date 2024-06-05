import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/create_serial_screen.dart';
import 'package:nb_utils/nb_utils.dart';

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
            10.height,
            _buildGTINText(context),
            10.height,
            _buildSerializationList(context),
            10.height,
            _buildCreateSerialsButton(context),
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
              onSubmitted: (value) {
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
              CaptureCubit.get(context).getSerializationData();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGTINText(BuildContext context) {
    return BlocBuilder<CaptureCubit, CaptureState>(
      builder: (context, state) {
        final gtin = CaptureCubit.get(context).gtin;
        if (gtin.text.isNotEmpty) {
          return Text(
            "GTIN: ${gtin.text}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primary,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSerializationList(BuildContext context) {
    return Expanded(
      flex: 4,
      child: BlocConsumer<CaptureCubit, CaptureState>(
        listener: (context, state) {
          if (state is CaptureSerializationSuccess) {
            CaptureCubit.get(context).serializationData = state.data;
          }
        },
        builder: (context, state) {
          if (state is CaptureSerializationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CaptureSerializationError) {
            return Center(child: Text(state.message));
          } else if (state is CaptureSerializationEmpty) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
              ),
              child: Center(
                child: Text(
                  "No data found with ${CaptureCubit.get(context).gtin} GTIN",
                ),
              ),
            );
          }

          final serializationData = CaptureCubit.get(context).serializationData;
          // if (serializationData.isNotEmpty) {
          //   return RefreshIndicator(
          //     onRefresh: () async {
          //       CaptureCubit.get(context).getSerializationData();
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         border: Border.all(color: AppColors.primary),
          //       ),
          //       child: SearchableList(
          //         shrinkWrap: true,
          //         filter: (query) {
          //           return serializationData.where((item) {
          //             return item.bATCH!.contains(query) ||
          //                 item.eXPIRYDATE!.contains(query) ||
          //                 item.serialNo!.contains(query);
          //           }).toList();
          //         },
          //         inputDecoration: const InputDecoration(
          //           hintText: 'Search',
          //           prefixIcon: Icon(Icons.search),
          //         ),
          //         initialList: serializationData,
          //         itemBuilder: (item) {
          //           final index = serializationData.indexOf(item) + 1;
          //           return Container(
          //             height: 40,
          //             alignment: Alignment.center,
          //             margin: const EdgeInsets.symmetric(
          //               vertical: 5,
          //               horizontal: 10,
          //             ),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(color: AppColors.primary),
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 Text("$index", style: const TextStyle(fontSize: 12)),
          //                 Text("${item.serialNo}",
          //                     style: const TextStyle(fontSize: 12)),
          //                 const SizedBox.shrink(),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   );
          // }
          if (CaptureCubit.get(context).gtinProducts.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                CaptureCubit.get(context).getSerializationData();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      CaptureCubit.get(context)
                              .gtinProducts[index]
                              .productnameenglish ??
                          "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      CaptureCubit.get(context).gtinProducts[index].barcode ??
                          "",
                      style: const TextStyle(fontSize: 13),
                    ),
                    leading: Hero(
                      tag: CaptureCubit.get(context).gtinProducts[index].id ??
                          "",
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${AppUrls.baseUrlWith3093}${CaptureCubit.get(context).gtinProducts[index].frontImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
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
                        // AppNavigator.goToPage(
                        //   context: context,
                        //   screen: GTINDetailsScreen(
                        //     employees: CaptureCubit.get(context).gtinProducts[index],
                        //   ),
                        // );
                      },
                      child: Image.asset("assets/icons/view.png"),
                    ),
                  ),
                  itemCount: CaptureCubit.get(context).serializationData.length,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCreateSerialsButton(context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement the create serials functionality
            AppNavigator.goToPage(
              context: context,
              screen: CreateSerialScreen(
                gtin: CaptureCubit.get(context).gtin.text,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pink,
            foregroundColor: AppColors.white,
          ),
          child: const Text(
            "Create Serials",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class GTINScreen extends StatefulWidget {
  const GTINScreen({super.key});

  @override
  State<GTINScreen> createState() => _GTINScreenState();
}

class _GTINScreenState extends State<GTINScreen> {
  TextEditingController searchController = TextEditingController();

  GtinCubit gtinBloc = GtinCubit();

  List<GTIN_Model> products = [];
  List<GTIN_Model> productsFiltered = [];

  String? userId, gcp, memberCategoryDescription;
  @override
  void initState() {
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    gtinBloc = gtinBloc..getGtinData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTIN'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SafeArea(
        child: BlocConsumer<GtinCubit, GtinState>(
          bloc: gtinBloc,
          listener: (context, state) {
            if (state is GtinLoadedState) {
              products = state.data;
              productsFiltered = state.data;
            }
          },
          builder: (context, state) {
            if (state is GtinLoadingState) {
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      title: Container(
                        width: 100,
                        height: 20,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        width: 100,
                        height: 20,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              );
            } else if (state is GtinErrorState) {
              return Center(
                child: Text(state.message),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Member ID",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            gcp.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "GCP",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            gcp.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Products",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            productsFiltered.length.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category C",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            memberCategoryDescription
                                .toString()
                                .replaceAll("Category C", ""),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/add_Icon.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                productsFiltered = products
                                    .where((element) => element.barcode
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            } else {
                              setState(() {
                                productsFiltered = products;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Ionicons.search_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GTIN List",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Ionicons.filter_outline,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: productsFiltered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (productsFiltered.isEmpty) {
                          return const Center(
                            child: Text('No products found'),
                          );
                        }

                        final productName =
                            productsFiltered[index].productnameenglish;
                        final barcode = productsFiltered[index].barcode;

                        // Remove any leading or trailing slashes from the cleaned path
                        final frontImage =
                            "https://gs1ksa.org:3093/${productsFiltered[index].frontImage?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}";

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              frontImage.toString(),
                            ),
                            onBackgroundImageError: (exception, stackTrace) =>
                                const Icon(Ionicons.image_outline),
                          ),
                          title: Text(
                            productName.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(barcode.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/add_Icon.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Remove Product'),
                                        content: const Text(
                                            'Are you sure you want to remove this product?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                products.removeAt(index);
                                              });
                                            },
                                            child: const Text('Remove'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/remove_icon.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

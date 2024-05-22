import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
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
        title: const Text('Bundling'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<GtinCubit, GtinState>(
          bloc: gtinBloc,
          listener: (context, state) {
            if (state is GtinLoadedState) {
              products = state.data;
              productsFiltered = state.data;
            } else if (state is GtinErrorState) {
              AppSnackbars.danger(context, state.message);
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
            } else if (state is GtinLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
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
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40,
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
                        child: SizedBox(
                          height: 30,
                          child: Image.asset(
                            'assets/icons/qr_code.png',
                            width: 20,
                            height: 20,
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
                      // border
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: productsFiltered.length,
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
                                productsFiltered[index].productnameenglish ??
                                    "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                productsFiltered[index].barcode ?? "",
                                style: const TextStyle(fontSize: 13),
                              ),
                              leading: Hero(
                                tag: productsFiltered[index].id ?? "",
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: productsFiltered[index]
                                                .frontImage ==
                                            null
                                        ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                        : "${AppUrls.baseUrl}${productsFiltered[index].frontImage?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: GTINDetailsScreen(
                                      employees: productsFiltered[index],
                                    ),
                                  );
                                },
                                child: Image.asset("assets/icons/view.png"),
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          // rgba(249, 75, 0, 1)
                          backgroundColor: const Color.fromRGBO(249, 75, 0, 1),
                        ),
                        child: const Text(
                          'Create Bundle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text("Total Of GTIN: ${productsFiltered.length}")
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

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
import 'package:gtrack_mobile_app/screens/home/identify/GTIN/add_gtin_screen.dart';
import 'package:gtrack_mobile_app/screens/home/identify/GTIN/gtin_information_screen.dart';
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

  List<GTIN_Model> products = [];
  List<GTIN_Model> productsFiltered = [];

  String? userId, gcp, memberCategoryDescription;
  @override
  void initState() {
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    context.read<GtinCubit>().getGtinData();
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
          listener: (context, state) {
            if (state is GtinLoadedState) {
              products = state.data;
              productsFiltered = state.data;
            } else if (state is GtinDeleteProductLoadedState) {
              AppSnackbars.success(context, "Product Successfully Deleted", 2);
              context.read<GtinCubit>().getGtinData();
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
            }
            // else if (state is GtinErrorState) {
            //   return Center(
            //     child: Text(state.message),
            //   );
            // }
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            gcp ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            gcp ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            productsFiltered.length.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            memberCategoryDescription?.replaceAll(
                                    "Category C", "") ??
                                "",
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
                      GestureDetector(
                        onTap: () {
                          AppNavigator.goToPage(
                            context: context,
                            screen: const AddGtinScreen(),
                          );
                        },
                        child: Container(
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
                  state is GtinLoadingState
                      ? Expanded(
                          child: Shimmer.fromColors(
                            baseColor: AppColors.grey,
                            highlightColor: AppColors.white,
                            child: Container(
                              height: 350,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 1,
                                ),
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            // border
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                context.read<GtinCubit>().getGtinData();
                              },
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
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      movementDuration:
                                          const Duration(seconds: 1),
                                      secondaryBackground: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Swipe to Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                            10.width,
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      background: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Swipe to Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                            10.width,
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      confirmDismiss: (direction) {
                                        return showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Are you sure?"),
                                            content: const Text(
                                                "Do you want to delete this product?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text("Yes"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text("No"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onDismissed: (direction) {
                                        context
                                            .read<GtinCubit>()
                                            .deleteGtinProductById(
                                                productsFiltered[index].id ??
                                                    "");
                                      },
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                          productsFiltered[index]
                                                  .productnameenglish ??
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
                                                  : "${AppUrls.baseUrlWith3093}${productsFiltered[index].frontImage?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
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
                                              screen: GTINInformationScreen(
                                                employees:
                                                    productsFiltered[index],
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                              "assets/icons/view.png"),
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                              ),
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

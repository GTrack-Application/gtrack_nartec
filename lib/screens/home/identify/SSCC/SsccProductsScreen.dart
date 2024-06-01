// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/sscc/sscc_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/sscc/sscc_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/SSCC/SsccModel.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class SsccProductsScreen extends StatefulWidget {
  const SsccProductsScreen({super.key});

  @override
  State<SsccProductsScreen> createState() => _SsccProductsScreenState();
}

class _SsccProductsScreenState extends State<SsccProductsScreen> {
  String total = "0";
  List<bool> isMarked = [];
  List<SsccModel> table = [];

  SsccCubit cubit = SsccCubit();

  TextEditingController searchController = TextEditingController();

  String? userId, gcp, memberCategoryDescription;

  @override
  void initState() {
    super.initState();
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    super.initState();
    Future.delayed(Duration.zero, () {
      cubit.getSsccData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SSCC Products".toUpperCase(),
        ),
        backgroundColor: AppColors.skyBlue,
      ),
      body: BlocConsumer<SsccCubit, SsccState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is SsccErrorState) {
          } else if (state is SsccLoadedState) {
            if (state.data.isEmpty) {
              toast("No data found for this user.");
            }
            table = state.data;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Column(
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
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {},
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
                        "SSCC List",
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
                state is SsccLoadingState
                    ? Shimmer.fromColors(
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
                      )
                    : state is SsccLoadedState
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                              itemCount: table.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: context.width() * 0.9,
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 5,
                                    top: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.skyBlue,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${index + 1}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          table[index].ssccType ?? "",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          table[index].sSCCBarcodeNumber ?? "",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TableDataSource extends DataTableSource {
  List<SsccModel> data;
  BuildContext ctx;

  TableDataSource(
    this.data,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final instance = data[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(instance.id ?? "")),
        DataCell(SelectableText(instance.ssccType ?? "")),
        DataCell(SelectableText(instance.sSCCBarcodeNumber ?? "")),
        DataCell(SelectableText(instance.description ?? "")),
        DataCell(SelectableText(instance.qty ?? "")),
        DataCell(SelectableText(instance.shipTo ?? "")),
        DataCell(SelectableText(instance.carton ?? "")),
        DataCell(SelectableText(instance.description ?? "")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

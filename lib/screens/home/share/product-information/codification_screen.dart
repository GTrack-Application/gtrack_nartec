import 'dart:developer' as dev;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/share/Similar_Records/record_states.dart';
import 'package:gtrack_mobile_app/blocs/share/Similar_Records/records_cubit.dart';
import 'package:gtrack_mobile_app/blocs/share/codification/codification_cubit.dart';
import 'package:gtrack_mobile_app/blocs/share/codification/codification_states.dart';
import 'package:gtrack_mobile_app/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';
import 'package:nb_utils/nb_utils.dart';

GtinInformationModel? gtinInformationModel;
GtinInformationDataModel? gtinInformationDataModel;

class CodificationScreen extends StatefulWidget {
  final String gtin;
  const CodificationScreen({super.key, required this.gtin});

  @override
  State<CodificationScreen> createState() => _CodificationScreenState();
}

class _CodificationScreenState extends State<CodificationScreen> {
  GtinInformationBloc gtinInformationBloc = GtinInformationBloc();
  CodificationCubit codificationCubit = CodificationCubit();
  RecordCubit recordsCubit = RecordCubit();

  @override
  void initState() {
    gtinInformationBloc = gtinInformationBloc
      ..add(GlobalDataEvent(widget.gtin));
    super.initState();
  }

  var isTapedContainer = -1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GtinInformationBloc, GlobalState>(
      bloc: gtinInformationBloc,
      listener: (context, state) {
        if (state is GlobalErrorState) {}
        if (state is GlobalLoadedState) {
          if (state.data is GtinInformationDataModel) {
            gtinInformationDataModel = state.data as GtinInformationDataModel;

            codificationCubit.getGpcInformation(
                gtinInformationDataModel!.data!.gpcCategoryCode.toString());

            recordsCubit.getRecords(
                gtinInformationDataModel!.data!.gpcCategoryName.toString());
          } else if (state.data is GtinInformationModel) {
            gtinInformationModel = state.data as GtinInformationModel;
          }
        }
      },
      builder: (context, state) {
        if (state is GlobalLoadingState) {
          return const Center(child: LoadingWidget());
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            isTapedContainer = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: isTapedContainer == index
                                ? Colors.yellow
                                : index == 0
                                    ? Colors.blue
                                    : Colors.blue[200],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://gs1ksa.org:3093/assets/gs1logowhite-QWHdyWZd.png",
                                  height: 50,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    index == 0 ? "GS1 GPC" : "HS CODES",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  20.height,
                  isTapedContainer == 0 || isTapedContainer == -1
                      ? BlocConsumer<CodificationCubit, CodificationState>(
                          bloc: codificationCubit,
                          listener: (context, st) {
                            if (st is CodificationError) {
                              toast(st.error);
                            }
                            if (st is CodificationLoaded) {}
                          },
                          builder: (context, state) {
                            return state is CodificationLoaded
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: TreeView(
                                      nodes: [
                                        TreeNode(
                                          content: Text(
                                            "Segment: - ${state.data.segmentTitle}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          children: [
                                            TreeNode(
                                              content: Text(
                                                "Family: - ${state.data.familyTitle}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              children: [
                                                TreeNode(
                                                  content: Text(
                                                    "Class: - ${state.data.classTitle}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  children: [
                                                    TreeNode(
                                                      content: Text(
                                                        "Brick: - ${state.data.brickTitle}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      children: [
                                                        TreeNode(
                                                          content:
                                                              const Text(""),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : TreeView(
                                    nodes: [
                                      TreeNode(
                                        content: const Text(
                                          "Segment: -",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        children: [
                                          TreeNode(
                                            content: const Text(
                                              "Family: -",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            children: [
                                              TreeNode(
                                                content: const Text(
                                                  "Class: -",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                children: [
                                                  TreeNode(
                                                    content: const Text(
                                                      "Brick: -",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    children: [
                                                      TreeNode(
                                                        content: const Text(""),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                          },
                        )
                      : BlocConsumer<RecordCubit, RecordsState>(
                          bloc: recordsCubit,
                          listener: (context, stt) {
                            if (stt is RecordsError) {
                              toast(stt.error);
                            }
                            if (stt is RecordsLoaded) {
                              print("Length: ${stt.data.length}");
                            }
                          },
                          builder: (context, stt) {
                            return stt is RecordsLoaded
                                ? Expanded(
                                    child: SizedBox(
                                      child: ListView.builder(
                                        itemCount: stt.data.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return BorderedRowWidget(
                                            value1: stt.data[index]
                                                .toString()
                                                .replaceAll("{", "")
                                                .replaceAll("}", "")
                                                .replaceAll("[", "")
                                                .replaceAll("]", ""),
                                            value2: stt.data[index]
                                                .toString()
                                                .replaceAll("{", "")
                                                .replaceAll("}", "")
                                                .replaceAll("[", "")
                                                .replaceAll("]", ""),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyTreeNode {
  const MyTreeNode({
    required this.title,
    this.children = const <MyTreeNode>[],
  });

  final String title;
  final List<MyTreeNode> children;
}

class BorderedRowWidget extends StatelessWidget {
  final String value1, value2;
  const BorderedRowWidget({
    super.key,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value1,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                value2,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class GtinInformationSource extends DataTableSource {
//   List<ProductContents> data = gtinInformationModel!.productContents!;

//   @override
//   DataRow getRow(int index) {
//     final rowData = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(rowData.productAllergenInformation.toString())),
//         DataCell(Text(rowData.productNutrientsInformation.toString())),
//         DataCell(Text(rowData.batch.toString())),
//         DataCell(Text(rowData.expiry.toString())),
//         DataCell(Text(rowData.serial.toString())),
//         DataCell(Text(rowData.manufacturingDate.toString())),
//         DataCell(Text(rowData.bestBeforeDate.toString())),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

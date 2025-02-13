import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/global/global_states_events.dart';
import 'package:gtrack_nartec/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_nartec/models/share/product_information/gtin_information_model.dart';
import 'package:ionicons/ionicons.dart';

GtinInformationModel? gtinInformationModel;
GtinInformationDataModel? gtinInformationDataModel;

class GtinInformationScreen extends StatefulWidget {
  final String gtin;
  const GtinInformationScreen({super.key, required this.gtin});

  @override
  State<GtinInformationScreen> createState() => _GtinInformationScreenState();
}

class _GtinInformationScreenState extends State<GtinInformationScreen> {
  GtinInformationBloc gtinInformationBloc = GtinInformationBloc();

  // Models

  @override
  void initState() {
    gtinInformationBloc = gtinInformationBloc
      ..add(GlobalDataEvent(widget.gtin));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GtinInformationBloc, GlobalState>(
      bloc: gtinInformationBloc,
      listener: (context, state) {
        if (state is GlobalLoadedState) {
          if (state.data is GtinInformationDataModel) {
            gtinInformationDataModel = state.data as GtinInformationDataModel;
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            onError: (exception, stackTrace) =>
                                const Icon(Ionicons.image_outline),
                            image: NetworkImage(
                              gtinInformationDataModel == null
                                  ? ""
                                  : "${AppUrls.baseUrlWith3093}${gtinInformationDataModel!.data!.productImageUrl!.value.toString().replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/")}",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BorderedRowWidget(
                        value1: "GTIN",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!.data!.gtin.toString(),
                      ),
                      BorderedRowWidget(
                        value1: "Brand name",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!.data!.brandName!.value
                                .toString(),
                      ),
                      BorderedRowWidget(
                        value1: "Product Description",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!
                                .data!.productDescription!.value
                                .toString(),
                      ),
                      BorderedRowWidget(
                        value1: "Image URL",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!
                                .data!.productImageUrl!.value
                                .toString(),
                      ),
                      BorderedRowWidget(
                        value1: "Global Product Category",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : "${gtinInformationDataModel!.data!.gpcCategoryCode.toString()} ${gtinInformationDataModel!.data!.gpcCategoryName.toString()}",
                      ),
                      BorderedRowWidget(
                        value1: "Net Content",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!.data!.moName.toString(),
                      ),
                      BorderedRowWidget(
                        value1: "Country Of Sale",
                        value2: gtinInformationDataModel == null
                            ? ""
                            : gtinInformationDataModel!.data!.countryOfSaleName
                                .toString(),
                      ),
                      SizedBox(height: 30),
                      // const Divider(thickness: 2),
                      SizedBox(height: 10),
                      // PaginatedDataTable(
                      //   columns: const [
                      //     DataColumn(label: Text("Allergen Info")),
                      //     DataColumn(label: Text("Nutrients Info")),
                      //     DataColumn(label: Text("Batch")),
                      //     DataColumn(label: Text("Expiry")),
                      //     DataColumn(label: Text("Serial")),
                      //     DataColumn(label: Text("Manufecturing Date")),
                      //     DataColumn(label: Text("Best Before")),
                      //   ],
                      //   source: GtinInformationSource(),
                      //   arrowHeadColor: AppColors.green,
                      //   showCheckboxColumn: false,
                      //   rowsPerPage: 5,
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
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
              flex: 3,
              child: Text(
                value1,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SelectableText(
                value2,
                style: const TextStyle(
                  fontSize: 13,
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

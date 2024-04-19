import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';
import 'package:nb_utils/nb_utils.dart';

GtinInformationModel? gtinInformationModel;
GtinInformationDataModel? gtinInformationDataModel;

class CompanyInformationScreen extends StatefulWidget {
  final String gtin;
  const CompanyInformationScreen({super.key, required this.gtin});

  @override
  State<CompanyInformationScreen> createState() =>
      _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {
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
          body: (gtinInformationModel == null &&
                  gtinInformationDataModel == null)
              ? const Center(child: LoadingWidget())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                "Information about the company that licenced this GTIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            BorderedRowWidget(
                              value1: "Company Name",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!
                                      .companyInfo!.companyName!
                                      .toString()
                                  : gtinInformationDataModel!.data!.companyName
                                      .toString(),
                            ),
                            BorderedRowWidget(
                              value1: "Address",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!
                                      .companyInfo!.formattedAddress!
                                      .toString()
                                  : gtinInformationDataModel!
                                      .data!.formattedAddress!
                                      .toString(),
                            ),
                            BorderedRowWidget(
                              value1: "Website",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!
                                      .companyInfo!.contactWebsite!
                                      .toString()
                                  : gtinInformationDataModel!
                                      .data!.contactWebsite!
                                      .toString(),
                            ),
                            BorderedRowWidget(
                              value1: "Licence Key",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!
                                      .companyInfo!.licenceKey!
                                      .toString()
                                  : gtinInformationDataModel!.data!.licenceKey
                                      .toString(),
                            ),
                            BorderedRowWidget(
                              value1: "Licence Type",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!
                                      .companyInfo!.licenceType!
                                      .toString()
                                  : gtinInformationDataModel!.data!.licenceKey
                                      .toString(),
                            ),
                            BorderedRowWidget(
                              value1: "Global Location Number (GLN)",
                              value2: gtinInformationDataModel == null
                                  ? gtinInformationModel!.companyInfo!.gtin!
                                      .toString()
                                  : gtinInformationDataModel!
                                      .data!.gpcCategoryCode
                                      .toString(),
                            ),
                            // const BorderedRowWidget(
                            //     value1: "Net Content", value2: gtinInformationDataModel!.data!.),
                            BorderedRowWidget(
                                value1: "Licensing GS1 Member Organisation",
                                value2: gtinInformationDataModel == null
                                    ? "${gtinInformationModel?.companyInfo?.primaryMOName}"
                                    : "${gtinInformationDataModel!.data!.countryOfSaleName}"),
                            30.height,
                            // const Divider(thickness: 2),
                            10.height,
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
              child: AutoSizeText(
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

GtinInformationModel? gtinInformationModel;

class GtinInformationScreen extends StatefulWidget {
  final String gtin;
  final String codeType;
  const GtinInformationScreen(
      {super.key, required this.gtin, required this.codeType});

  @override
  State<GtinInformationScreen> createState() => _GtinInformationScreenState();
}

class _GtinInformationScreenState extends State<GtinInformationScreen> {
  GtinInformationBloc gtinInformationBloc = GtinInformationBloc();

  // Models

  @override
  void initState() {
    final gtin = widget.codeType == "1D"
        ? widget.gtin
        : widget.gtin.split("-")[0].replaceAll("", "");

    gtinInformationBloc = gtinInformationBloc..add(GlobalDataEvent(gtin));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GtinInformationBloc, GlobalState>(
      bloc: gtinInformationBloc,
      listener: (context, state) {
        if (state is GlobalLoadedState) {
          gtinInformationModel = state.data as GtinInformationModel;
        }
      },
      builder: (context, state) {
        if (state is GlobalLoadingState) {
          return const Center(child: LoadingWidget());
        } else if (state is GlobalErrorState) {
          return Center(child: Text(state.message));
        } else if (state is GlobalLoadedState) {
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
                              onError: (exception, stackTrace) => const Icon(
                                Ionicons.image_outline,
                              ),
                              image: CachedNetworkImageProvider(
                                gtinInformationModel!.gtinArr!.productImageUrl
                                    .toString(),
                                errorListener: () =>
                                    const Icon(Ionicons.image_outline),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BorderedRowWidget(
                          value1: "GTIN",
                          value2:
                              gtinInformationModel!.gtinArr!.gtin.toString(),
                        ),
                        BorderedRowWidget(
                          value1: "Brand name",
                          value2: gtinInformationModel!.gtinArr!.brandName
                              .toString(),
                        ),
                        BorderedRowWidget(
                          value1: "Product Description",
                          value2: gtinInformationModel!
                              .gtinArr!.productDescription
                              .toString(),
                        ),
                        BorderedRowWidget(
                          value1: "Image URL",
                          value2: gtinInformationModel!.gtinArr!.productImageUrl
                              .toString(),
                        ),
                        BorderedRowWidget(
                          value1: "Global Product Category",
                          value2: gtinInformationModel!.gtinArr!.gpcCategoryCode
                              .toString(),
                        ),
                        // const BorderedRowWidget(
                        //     value1: "Net Content", value2: gtinInformationModel!.gtinArr!.),
                        BorderedRowWidget(
                          value1: "Country Of Sale",
                          value2: gtinInformationModel!
                              .gtinArr!.countryOfSaleCode
                              .toString(),
                        ),
                        30.height,
                        const Divider(thickness: 2),
                        10.height,
                        PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Text("Allergen Info")),
                            DataColumn(label: Text("Nutrients Info")),
                            DataColumn(label: Text("Batch")),
                            DataColumn(label: Text("Expiry")),
                            DataColumn(label: Text("Serial")),
                            DataColumn(label: Text("Manufecturing Date")),
                            DataColumn(label: Text("Best Before")),
                          ],
                          source: GtinInformationSource(),
                          arrowHeadColor: AppColors.green,
                          showCheckboxColumn: false,
                          rowsPerPage: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("Something went wrong"));
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
              child: Text(
                value1,
                style: const TextStyle(
                  fontSize: 15,
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

class GtinInformationSource extends DataTableSource {
  List<ProductContents> data = gtinInformationModel!.productContents!;

  @override
  DataRow getRow(int index) {
    final rowData = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rowData.productAllergenInformation.toString())),
        DataCell(Text(rowData.productNutrientsInformation.toString())),
        DataCell(Text(rowData.batch.toString())),
        DataCell(Text(rowData.expiry.toString())),
        DataCell(Text(rowData.serial.toString())),
        DataCell(Text(rowData.manufacturingDate.toString())),
        DataCell(Text(rowData.bestBeforeDate.toString())),
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

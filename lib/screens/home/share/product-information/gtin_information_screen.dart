import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/table_header_text.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

class GtinInformationScreen extends StatefulWidget {
  const GtinInformationScreen({super.key});

  @override
  State<GtinInformationScreen> createState() => _GtinInformationScreenState();
}

class _GtinInformationScreenState extends State<GtinInformationScreen> {
  GtinInformationBloc gtinInformationBloc = GtinInformationBloc();

  // Models
  GtinInformationModel? gtinInformationModel;

  @override
  void initState() {
    gtinInformationBloc = gtinInformationBloc..add(GlobalInitEvent());
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
                        BorderedRowWidget(value1: "Net Content", value2: "123"),
                        BorderedRowWidget(
                          value1: "Country Of Sale",
                          value2: gtinInformationModel!
                              .gtinArr!.countryOfSaleCode
                              .toString(),
                        ),
                        10.height,
                        const Divider(thickness: 2),
                        10.height,
                        // Create a horizontal scrollable table with the following columns:
                        // - Allergen Info
                        // - Nutrients Info
                        // - Batch
                        // - Expiry
                        // - Serial
                        // - Manufacturing Date
                        // - Best Before

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              dataRowColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return AppColors.green;
                                  }
                                  return AppColors.background;
                                },
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                border:
                                    Border.all(color: AppColors.grey, width: 1),
                              ),
                              dividerThickness: 2,
                              border: const TableBorder(
                                horizontalInside: BorderSide(
                                  color: AppColors.grey,
                                  width: 2,
                                ),
                                verticalInside: BorderSide(
                                  color: AppColors.grey,
                                  width: 2,
                                ),
                              ),
                              columns: const [
                                DataColumn(
                                  label: TableHeaderText(text: 'Allergen Info'),
                                ),
                                DataColumn(
                                    label: TableHeaderText(
                                        text: 'Nutrients Info')),
                                DataColumn(
                                    label: TableHeaderText(text: 'Batch')),
                                DataColumn(
                                    label: TableHeaderText(text: 'Expiry')),
                                DataColumn(
                                    label: TableHeaderText(text: 'Serial')),
                                DataColumn(
                                    label: TableHeaderText(
                                        text: 'Manufacturing Date')),
                                DataColumn(
                                    label:
                                        TableHeaderText(text: 'Best Before')),
                              ],
                              rows: gtinInformationModel!.productContents!
                                  .map(
                                    (e) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            e.allergenInfo.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            e.productNutrientsInformation
                                                .toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(e.batch.toString()),
                                        ),
                                        DataCell(
                                          Text(e.expiry.toString()),
                                        ),
                                        DataCell(
                                          Text(e.serial.toString()),
                                        ),
                                        DataCell(
                                          Text(e.manufacturingDate.toString()),
                                        ),
                                        DataCell(
                                          Text(e.bestBeforeDate.toString()),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
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

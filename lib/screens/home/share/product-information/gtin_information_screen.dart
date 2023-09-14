import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/share/product_information/gtin_information_bloc.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/share/product_information/gtin_information_model.dart';

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
          return const Center(child: CircularProgressIndicator());
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
                                image: NetworkImage(gtinInformationModel!
                                    .gtinArr!.productImageUrl
                                    .toString()),
                                fit: BoxFit.contain,
                                onError: (exception, stackTrace) =>
                                    const Center(
                                      child: Text("Image not found"),
                                    )),
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

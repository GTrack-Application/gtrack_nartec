import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/blocs/gtin/gtin_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/gtin_model.dart';
import 'package:ionicons/ionicons.dart';

class GTINScreen extends StatefulWidget {
  const GTINScreen({Key? key}) : super(key: key);

  @override
  State<GTINScreen> createState() => _GTINScreenState();
}

class _GTINScreenState extends State<GTINScreen> {
  GtinBloc gtinBloc = GtinBloc();
  GTINModel gtinModel = GTINModel();

  String? userId, gcp, memberCategoryDescription;
  @override
  void initState() {
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    gtinBloc = gtinBloc..add(GlobalInitEvent());
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
        child: BlocConsumer<GtinBloc, GlobalState>(
          bloc: gtinBloc,
          listener: (context, state) {
            if (state is GlobalLoadedState) {
              gtinModel = state.data as GTINModel;
            }
          },
          builder: (context, state) {
            if (state is GlobalLoadingState) {
              return const Center(
                child: LoadingWidget(),
              );
            } else if (state is GlobalErrorState) {
              return Center(
                child: Text(state.message),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBoxText(text: "Member Id: $userId"),
                      CustomBoxText(
                        text: "GCP: $gcp",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBoxText(
                        text: memberCategoryDescription.toString(),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: gtinModel.products?.length,
                      itemBuilder: (context, index) {
                        final productName =
                            gtinModel.products?[index].productnameenglish;
                        final barcode = gtinModel.products?[index].barcode;
                        final brandName = gtinModel.products?[index].brandName;
                        final frontImage =
                            "${gtinModel.imagePath}/${gtinModel.products?[index].frontImage}";

                        return Card(
                          elevation: 2,
                          color: AppColors.background,
                          child: ListTile(
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
                            trailing: Text(brandName.toString()),
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

class CustomBoxText extends StatelessWidget {
  const CustomBoxText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.skyBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.background),
          ),
        ),
      ),
    );
  }
}

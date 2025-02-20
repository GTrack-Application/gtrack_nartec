import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packaging/packaging_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/utils/date_time_format.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';

class PackagingScreen extends StatelessWidget {
  const PackagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packaging'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Show nice dialog
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Packaing Box'),
                          backgroundColor: AppColors.background,
                          children: [
                            // create a wrap widget of 3 columns and 5 elements total
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  buildPackingBox(
                                    title: "Pallet",
                                    icon: AppIcons.transferPallet,
                                    onTap: () {
                                      Navigator.pop(context);
                                      showPackagingTypeSheet(context,
                                          type: 'Pallet');
                                    },
                                  ),
                                  buildPackingBox(
                                      title: "Box/Carton",
                                      icon: AppIcons.aggCompiling,
                                      onTap: () {
                                        Navigator.pop(context);
                                        showPackagingTypeSheet(context,
                                            type: 'Box/Carton');
                                      }),
                                  buildPackingBox(
                                      title: "Bundle",
                                      icon: AppIcons.aggCompiling,
                                      onTap: () {
                                        Navigator.pop(context);
                                        showPackagingTypeSheet(context,
                                            type: 'Bundle');
                                      }),
                                  buildPackingBox(
                                      title: "Pack",
                                      icon: AppIcons.aggCompiling,
                                      onTap: () {
                                        Navigator.pop(context);
                                        showPackagingTypeSheet(context,
                                            type: 'Pack');
                                      }),
                                  buildPackingBox(
                                      title: "Piece",
                                      icon: AppIcons.aggCompiling,
                                      onTap: () {
                                        Navigator.pop(context);
                                        showPackagingTypeSheet(context,
                                            type: 'Piece');
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Row(
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.print,
                          color: AppColors.white,
                        ),
                        const Text(
                          "Packaing Box",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              color: Colors.grey,
            ))
          ],
        ),
      ),
    );
  }

  Widget buildPackingBox(
      {required String title, required String icon, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.pink.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.background),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          spacing: 4.0,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.background,
              child: Image.asset(icon, height: 60, width: 60),
            ),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showPackagingTypeSheet(BuildContext context, {String? type}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      // full height
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<PackagingCubit, PackagingState>(
          listener: (context, state) {
            if (state is PackagingScanError) {
              AppSnackbars.normal(context, state.message);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Packaging Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.pink),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pack Type: ${type ?? ""}'),
                      //   const SizedBox(height: 8),
                      //   Text(
                      //       'Pack Date: ${DateTime.now().toString().split(' ')[0]}'),
                      //   const SizedBox(height: 8),
                      //   Text(
                      //       'Transaction Id: TRX${DateTime.now().millisecondsSinceEpoch}'),
                    ],
                  ),
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormFieldWidget(
                        controller:
                            context.read<PackagingCubit>().ssccController,
                      ),
                    ),

                    // Filled Button
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: PrimaryButtonWidget(
                          text: "Scan",
                          onPressed: () {
                            if (state is PackagingScanLoading) {
                              return;
                            }
                            context.read<PackagingCubit>().scanItem();
                          },
                          isLoading: state is PackagingScanLoading,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: context.read<PackagingCubit>().items.length,
                    itemBuilder: (context, index) {
                      final item = context.read<PackagingCubit>().items[index];
                      return Card(
                        color: AppColors.background,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Map Date: ${dateFormat(item.mapDate ?? "")}",
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.pink,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Bin Location: ${(item.binLocation)}",
                                        style: TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "SSCC: ${item.gTIN}",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Count: ${item.cID}",
                                style: TextStyle(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "PO: ${item.pO}",
                                style: TextStyle(
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      // Handle complete transaction
                    },
                    child: Text('COMPLETE TRANSACTION'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

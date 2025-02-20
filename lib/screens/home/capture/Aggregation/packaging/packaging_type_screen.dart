import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packaging/packaging_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/utils/date_time_format.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/screens/home_screen.dart';

class PackagingTypeScreen extends StatefulWidget {
  final String type, slug;
  const PackagingTypeScreen({
    super.key,
    required this.type,
    required this.slug,
  });

  @override
  State<PackagingTypeScreen> createState() => _PackagingTypeScreenState();
}

class _PackagingTypeScreenState extends State<PackagingTypeScreen> {
  final _selectedDate = DateTime.now();

  late PackagingCubit packagingCubit;
  @override
  void initState() {
    super.initState();
    packagingCubit = PackagingCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packaging Type'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<PackagingCubit, PackagingState>(
          bloc: packagingCubit,
          listener: (context, state) {
            if (state is PackagingScanError) {
              AppSnackbars.normal(context, state.message);
            }
            if (state is PackagingInsertError) {
              AppSnackbars.danger(context, state.message);
            }
            if (state is PackagingInsertLoaded) {
              AppNavigator.pushAndRemoveUntil(
                context: context,
                screen: const HomeScreen(),
              );
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
                    spacing: 8.0,
                    children: [
                      Text('Pack Type: ${widget.type}'),
                      Text(
                          'Pack Date: ${_selectedDate.toString().split(' ')[0]}'),
                      Text(
                        'Transaction Id: TRX${_selectedDate.millisecondsSinceEpoch}',
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormFieldWidget(
                        controller: packagingCubit.ssccController,
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
                            packagingCubit.scanItem();
                          },
                          isLoading: state is PackagingScanLoading,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: packagingCubit.items.length,
                    itemBuilder: (context, index) {
                      final item = packagingCubit.items[index];
                      return GestureDetector(
                        onTap: () {
                          showPalletItemsBottomSheet(
                              context, item.palletCode ?? "");
                        },
                        child: Card(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            "Bin Location: ${(item.binLocation)}",
                                            style: TextStyle(
                                              color: AppColors.white,
                                            ),
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
                                  "Count: ${packagingCubit.itemsWithPallet[item.palletCode]?['count'] ?? 0}",
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
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryButtonWidget(
                    backgroungColor: packagingCubit.itemsWithPallet.isNotEmpty
                        ? AppColors.pink
                        : Colors.grey,
                    text: "Complete Transaction",
                    isLoading: state is PackagingInsertLoading,
                    onPressed: () {
                      if (state is PackagingInsertLoading) {
                        return;
                      }
                      packagingCubit.insertPackaging(widget.slug);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  void showPalletItemsBottomSheet(BuildContext context, String sscc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('SSCC Number: $sscc'),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                    packagingCubit.itemsWithPallet[sscc]?['items']?.length ?? 0,
                itemBuilder: (context, index) {
                  final item =
                      packagingCubit.itemsWithPallet[sscc]?['items']?[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GTIN: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.pink,
                                    ),
                                  ),
                                  Text(item.gTIN ?? ''),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  // 1D Barcode
                                  SizedBox(
                                    height: 50,
                                    child: BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: item.gTIN ?? '',
                                      drawText: false,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // QR Code
                                  SizedBox(
                                    height: 42,
                                    child: BarcodeWidget(
                                      barcode: Barcode.qrCode(),
                                      data: item.gTIN ?? '',
                                      drawText: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _buildItemRow('Item Code:', item.itemCode ?? '',
                            item.itemCode != null),
                        _buildItemRow('Description:', item.itemDesc ?? '',
                            item.itemDesc != null),
                        _buildItemRow('Serial No:', item.itemSerialNo ?? '',
                            item.itemSerialNo != null),
                        _buildItemRow('Location:', item.mainLocation ?? '',
                            item.mainLocation != null),
                        _buildItemRow('Bin:', item.binLocation ?? '',
                            item.binLocation != null),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String label, String value, bool isValid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? AppColors.green : AppColors.pink,
            size: 20,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/goods_receipt/job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/utils/date_time_format.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bom_start_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/job_order_bom_start_screen1.dart';

class SalesOrderScanAssetScreen extends StatefulWidget {
  const SalesOrderScanAssetScreen({
    super.key,
    required this.barcode,
    required this.bomStartData,
    this.isSalesOrder = false,
  });

  final String barcode;
  final bool? isSalesOrder;
  final BomStartModel bomStartData;

  @override
  State<SalesOrderScanAssetScreen> createState() =>
      _SalesOrderScanAssetScreenState();
}

class _SalesOrderScanAssetScreenState extends State<SalesOrderScanAssetScreen> {
  final controller = TextEditingController();
  late JobOrderCubit jobOrderCubit;
  DateTime transferDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // jobOrderCubit = JobOrderCubit.get(context);
    jobOrderCubit = JobOrderCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Packages'),
        backgroundColor: AppColors.pink,
      ),
      body: BlocConsumer<JobOrderCubit, JobOrderState>(
        bloc: jobOrderCubit,
        listener: (context, state) {
          if (state is AssetsByTagNumberError) {
            AppSnackbars.warning(context, state.message);
          } else if (state is AssetsByTagNumberLoaded) {
            controller.clear();
          } else if (state is SaveAssetTagsError) {
            AppSnackbars.warning(context, state.message);
          } else if (state is SaveAssetTagsLoaded) {
            AppSnackbars.normal(context, 'Assets saved successfully');
            AppNavigator.goToPage(
              context: context,
              screen: JobOrderBomStartScreen1(
                gtin: widget.barcode,
                productName: widget.bomStartData.productnameenglish ?? '',
                isSalesOrder: widget.isSalesOrder,
              ),
            );
          } else if (state is PackagingScanError) {
            AppSnackbars.warning(context, state.message);
          } else if (state is PackagingScanLoaded) {
            controller.clear();
            AppSnackbars.normal(context, 'Package scanned successfully');
          }
        },
        builder: (context, state) {
          // Use packageResults instead of assets to check if we have scanned items
          final scanned = jobOrderCubit.packagingScanResults.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormFieldWidget(
                        controller: controller,
                        hintText: "Enter/Scan Tag Number",
                        onEditingComplete: () {
                          jobOrderCubit.scanPackagingBySscc(
                            controller.text.trim(),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PrimaryButtonWidget(
                        text: "Scan",
                        onPressed: () {
                          jobOrderCubit.scanPackagingBySscc(
                            controller.text.trim(),
                          );
                        },
                        backgroundColor: AppColors.pink,
                        isLoading: state is AssetsByTagNumberLoading,
                      ),
                    ),
                  ],
                ),
                // Assets Table
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      //   border: Border.all(color: AppColors.grey),
                    ),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: scanned
                        ? _buildScannedSection()
                        : _buildNotScannedSection(),
                  ),
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: PrimaryButtonWidget(
                        height: 35,
                        text: "Back",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: AppColors.pink,
                      ),
                    ),
                    Expanded(
                      child: PrimaryButtonWidget(
                        height: 35,
                        text: "Save",
                        onPressed: () {
                          final order = context
                              .read<ProductionJobOrderCubit>()
                              .selectedSubSalesOrder;

                          jobOrderCubit.saveAssetTagsForSalesOrder(
                            widget.bomStartData.id ?? '',
                            transferDate,
                            order,
                          );
                        },
                        backgroundColor: AppColors.green,
                        isLoading: state is SaveAssetTagsLoading,
                      ),
                    ),
                    Visibility(
                      visible: jobOrderCubit.isSaveAssetTagsForSalesOrder,
                      child: Expanded(
                        child: PrimaryButtonWidget(
                          height: 35,
                          text: "Next",
                          onPressed: () {
                            AppNavigator.goToPage(
                              context: context,
                              screen: JobOrderBomStartScreen1(
                                gtin: widget.barcode,
                                productName:
                                    widget.bomStartData.productnameenglish ??
                                        '',
                                isSalesOrder: widget.isSalesOrder,
                              ),
                            );
                          },
                          backgroundColor: AppColors.skyBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScannedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section with package count
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.pink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.pink.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.pink, size: 18),
              const SizedBox(width: 8),
              Text(
                "Scanned Packages: ${jobOrderCubit.packagingScanResults.keys.length}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Package cards list
        Expanded(
          child: jobOrderCubit.packagingScanResults.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No packages scanned yet",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: jobOrderCubit.packagingScanResults.length,
                  itemBuilder: (context, index) {
                    final ssccNo = jobOrderCubit.packagingScanResults.keys
                        .elementAt(index);
                    final packageList =
                        jobOrderCubit.packagingScanResults[ssccNo] ?? [];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.qr_code, color: AppColors.pink),
                                const SizedBox(width: 8),
                                Text(
                                  "SSCC: $ssccNo",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                // Show count of items
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${packageList.length} items",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.pink,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            // List of items in the package
                            ...packageList
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description: ${item['description'] ?? 'N/A'}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              "Serial GTIN: ${item['serialGTIN'] ?? 'N/A'}"),
                                          const SizedBox(height: 4),
                                          Text(
                                              "Serial No: ${item['serialNo'] ?? 'N/A'}"),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        Divider(color: AppColors.grey.withValues(alpha: 0.3)),

        // DateTime Picker Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Transfer Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: transferDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.pink,
                            onPrimary: AppColors.white,
                            surface: AppColors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      transferDate = picked;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.grey.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppColors.pink,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat(transferDate.toIso8601String()),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotScannedSection() {
    return Column(
      children: [
        Text(
          'No Assets Scanned Yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Start scanning assets by entering the TAG number above or use the scanner to add assets to you list',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        _buildRow(1, 'Enter the TAG number'),
        _buildRow(2, 'Click Scan or user Scanner'),
        _buildRow(3, 'View Scanned Assets in the table below'),
      ],
    );
  }

  Widget _buildRow(int no, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey),
        ),
      ),
      child: Row(
        children: [
          Text(
            "$no. ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.pink,
            ),
          ),
          Expanded(
            child: Text(title),
          ),
        ],
      ),
    );
  }
}

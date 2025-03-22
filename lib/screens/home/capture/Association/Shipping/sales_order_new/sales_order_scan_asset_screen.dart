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
        title: Text('Sales Order Scan Asset'),
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
            // AppNavigator.goToPage(
            //   context: context,
            //   screen: JobOrderItemDetailsScreen(order: widget.order),
            // );
            AppNavigator.goToPage(
              context: context,
              screen: JobOrderBomStartScreen1(
                gtin: widget.barcode,
                productName: widget.bomStartData.productnameenglish ?? '',
                isSalesOrder: widget.isSalesOrder,
              ),
            );
          }
        },
        builder: (context, state) {
          final scanned = jobOrderCubit.assets.isNotEmpty;
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
                          jobOrderCubit.getAssetsByTagNumber(
                            controller.text.trim(),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PrimaryButtonWidget(
                        text: "Scan",
                        onPressed: () {
                          jobOrderCubit.getAssetsByTagNumber(
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
        // Header section with asset count
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
                "Scanned Assets: ${jobOrderCubit.assets.length}",
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

        // Assets table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.pink,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Text(
                "Tag Number",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                "Transfer Date",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        // Assets list
        Flexible(
          child: jobOrderCubit.assets.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No assets scanned yet",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: jobOrderCubit.assets.length,
                  separatorBuilder: (context, index) => Divider(
                      height: 1, color: AppColors.grey.withValues(alpha: 0.2)),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? AppColors.grey.withValues(alpha: 0.05)
                            : AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 16,
                                color: AppColors.pink,
                              ),
                              Expanded(
                                child: Text(
                                  jobOrderCubit.assets[index].tagNumber ?? '',
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                dateFormat(transferDate.toIso8601String()),
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          TextFormFieldWidget(
                            controller:
                                jobOrderCubit.assets[index].productionLine!,
                            hintText: "Production Line",
                          ),
                        ],
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
                    final TimeOfDay? timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(transferDate),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.pink,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (timePicked != null) {
                      setState(() {
                        transferDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          timePicked.hour,
                          timePicked.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.grey.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.pink,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateTimeFormat(transferDate.toIso8601String()),
                        style: TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.grey,
                        size: 20,
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

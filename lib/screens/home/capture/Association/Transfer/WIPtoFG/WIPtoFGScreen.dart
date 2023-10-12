import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/SSCC/SsccProductsModel.dart';

class WIPtoFGScreen extends StatefulWidget {
  const WIPtoFGScreen({super.key});

  @override
  State<WIPtoFGScreen> createState() => _WIPtoFGScreenState();
}

class _WIPtoFGScreenState extends State<WIPtoFGScreen> {
  final TextEditingController jobOrderNoController = TextEditingController();

  String total = "0";
  List<bool> isMarked = [];
  List<SsccProductsModel> table = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('WIP to FG'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 5),
                child: const TextWidget(
                  text: "Job Order No.",
                  fontSize: 16,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextFormFieldWidget(
                        controller: jobOrderNoController,
                        hintText: "Enter/Scan Job Order No.",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Image.asset(
                          AppImages.finder,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
                child: PaginatedDataTable(
                  rowsPerPage: 5,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'SSCC ID',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Type',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'SSCC Barcode Number',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: TableDataSource(table, context),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: ElevatedButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  fontSize: 16,
                  title: "Confirm All ?",
                  textColor: Colors.white,
                  color: AppColors.pink,
                  onPressed: () {
                    // show dialog for confirmation
                    Get.defaultDialog(
                      title: "Confirmation",
                      titleStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      middleText: "Are you sure you want to confirm all?",
                      middleTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      backgroundColor: Colors.white,
                      radius: 10,
                      actions: [
                        ElevatedButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          title: "Yes",
                          fontSize: 15,
                          textColor: Colors.white,
                          color: AppColors.pink,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButtonWidget(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          title: "No",
                          fontSize: 15,
                          textColor: Colors.white,
                          color: AppColors.pink,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TableDataSource extends DataTableSource {
  List<SsccProductsModel> data;
  BuildContext ctx;

  TableDataSource(
    this.data,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final instance = data[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(Text(instance.ssccId.toString() == "null"
            ? "0"
            : instance.ssccId.toString())),
        DataCell(Text(instance.type ?? "")),
        DataCell(Text(instance.sSCCBarcodeNumber ?? "")),
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

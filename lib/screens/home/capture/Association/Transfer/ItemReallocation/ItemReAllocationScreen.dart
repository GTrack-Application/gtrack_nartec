// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Transfer/ItemReallocation/ItemReAllocationTableDataController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Transfer/ItemReallocation/SubmitItemReallocateController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';

import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';

class ItemReAllocationScreen extends StatefulWidget {
  const ItemReAllocationScreen({super.key});

  @override
  State<ItemReAllocationScreen> createState() => _ItemReAllocationScreenState();
}

class _ItemReAllocationScreenState extends State<ItemReAllocationScreen> {
  final TextEditingController _palletIdController = TextEditingController();
  final TextEditingController _scanSerialItemController =
      TextEditingController();

  String total = "0";

  List<GetItemInfoByPalletCodeModel> table = [];
  List<bool> isMarked = [];

  String _site = "Allocation";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarWidget(
          backgroundColor: AppColors.pink,
          autoImplyLeading: true,
          onPressed: () {
            Get.back();
          },
          title: "Pallet Re-Allocation".toUpperCase(),
          actions: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  AppImages.delete,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: AppColors.pink.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'Allocation',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        leading: Radio(
                          value: "Allocation",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'Picking',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        leading: Radio(
                          value: "Picking",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Pallet ID",
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
                        controller: _palletIdController,
                        hintText: "Enter/Scan Pallet ID",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          palletIdMethod();
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
                          palletIdMethod();
                        },
                        child: Image.asset(
                          AppImages.finder,
                          width: 45,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: PaginatedDataTable(
                  rowsPerPage: 4,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Item Code',
                      style: TextStyle(color: Colors.blue),
                    )),
                    DataColumn(
                        label: Text(
                      'Item Desc',
                      style: TextStyle(color: Colors.blue),
                    )),
                    DataColumn(
                        label: Text(
                      'GTIN',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Remarks',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'User',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Classification',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Main Location',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Bin Location',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Int Code',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Item Serial No.',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Map Date',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Pallet Code',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Reference',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'SID',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'CID',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'PO',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Trans',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: SourceData(table, context),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Serial Item",
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _scanSerialItemController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan Serial Item",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButtonWidget(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        title: "Save",
                        textColor: Colors.white,
                        color: AppColors.pink,
                        onPressed: () {
                          if (_site.isEmpty ||
                              _scanSerialItemController.text.isEmpty ||
                              _palletIdController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all the fields"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          // unFocus from textfield
                          FocusScope.of(context).requestFocus(FocusNode());
                          AppDialogs.loadingDialog(context);

                          SubmitItemReallocateControllerimport.postData(
                            table,
                            _palletIdController.text.trim(),
                            _scanSerialItemController.text.trim(),
                            _site,
                          ).then((value) {
                            setState(() {
                              table.clear();
                              _scanSerialItemController.clear();
                              _site = "";
                              _palletIdController.clear();
                            });
                            AppDialogs.closeDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Reallocation Successfully done"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }).onError((error, stackTrace) {
                            AppDialogs.closeDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", "")),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const TextWidget(text: "TOTAL", fontSize: 20),
                      const SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextWidget(text: total),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void palletIdMethod() {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);

    ItemReAllocationTableDataController.getAllTable(
            _palletIdController.text.trim())
        .then((value) {
      setState(() {
        table = value;
        isMarked = List<bool>.filled(
          table.length,
          false,
        );
        total = table.length.toString();
      });
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

class SourceData extends DataTableSource {
  List<GetItemInfoByPalletCodeModel> students;
  BuildContext ctx;

  SourceData(
    this.students,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) {
      return null;
    }

    final data = students[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(data.itemCode ?? "")),
        DataCell(SelectableText(data.itemDesc ?? "")),
        DataCell(SelectableText(data.gTIN ?? "")),
        DataCell(SelectableText(data.remarks ?? "")),
        DataCell(SelectableText(data.user ?? "")),
        DataCell(SelectableText(data.classification ?? "")),
        DataCell(SelectableText(data.mainLocation ?? "")),
        DataCell(SelectableText(data.binLocation ?? "")),
        DataCell(SelectableText(data.intCode ?? "")),
        DataCell(SelectableText(data.itemSerialNo ?? "")),
        DataCell(SelectableText(data.mapDate ?? "")),
        DataCell(SelectableText(data.palletCode ?? "")),
        DataCell(SelectableText(data.reference ?? "")),
        DataCell(SelectableText(data.sID ?? "")),
        DataCell(SelectableText(data.cID ?? "")),
        DataCell(SelectableText(data.pO ?? "")),
        DataCell(SelectableText(data.trans.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}

// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'package:dropdown_search/dropdown_search.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Transfer/RawMaterialsToWIPS/RawMaterialsToWIPScreen2.dart';

// ignore: must_be_immutable
class RawMaterialsToWIPScreen1 extends StatefulWidget {
  String? pickedQty;

  RawMaterialsToWIPScreen1({this.pickedQty});

  @override
  State<RawMaterialsToWIPScreen1> createState() =>
      _RawMaterialsToWIPScreen1State();
}

class _RawMaterialsToWIPScreen1State extends State<RawMaterialsToWIPScreen1> {
  String total = "0";
  List<GetSalesPickingListCLRMByAssignToUserAndVendorModel> table = [];
  List<bool> isMarked = [];

  String? userId;
  String? vendorId;

  void getPref() {
    AppPreferences.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
    AppPreferences.getVendorId().then((value) {
      setState(() {
        vendorId = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();

    Future.delayed(Duration.zero, () {
      AppDialogs.loadingDialog(context);
      RawMaterialsToWIPController
          .getSalesPickingListCLRMByAssignToUserAndVendorController(
        int.parse(userId ?? ""),
        int.parse(vendorId ?? ""),
      ).then((value) {
        setState(() {
          table = value;
          total = value.length.toString();
          isMarked = List<bool>.filled(value.length, false);
        });
        AppDialogs.closeDialog();
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        AppSnackbars.normal(
            context, error.toString().replaceAll("Exception:", ""));
      });
    });
  }

  String? dropDownValue = "Raw Material Warehouse";
  List<String> dropDownList = [
    "Raw Material Warehouse",
    "Plant Factory",
    "Finished Goods Warehouse",
    "Distribution Center",
  ];

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
          title: "Raw Materials To WIP",
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
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: AppColors.pink.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextWidget(
                      text: "Current Logged In User: ",
                      fontSize: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: TextWidget(
                        text: userId ?? "",
                        fontSize: 16,
                        color: AppColors.pink,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Bin (FROM)*",
                  fontSize: 16,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(left: 20),
                child: DropdownSearch<String>(
                  filterFn: (item, filter) {
                    return item.toLowerCase().contains(filter.toLowerCase());
                  },
                  enabled: true,
                  dropdownButtonProps: const DropdownButtonProps(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  items: dropDownList,
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value!;
                    });
                  },
                  selectedItem: dropDownValue,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 1,
                child: PaginatedDataTable(
                  rowsPerPage: 5,
                  header: const TextWidget(
                    text: "List of Items",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  columns: const [
                    DataColumn(
                        label: Text(
                      'id',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'assign_to_userid',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'product_name',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'quantity',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'productid',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'job_order_number',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'transaction_date',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'created',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'vendor_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: SourceData(
                    table,
                    context,
                    dropDownValue ?? "",
                  ),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
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

class SourceData extends DataTableSource {
  List<GetSalesPickingListCLRMByAssignToUserAndVendorModel> students;
  BuildContext ctx;
  String binLocation;

  SourceData(
    this.students,
    this.ctx,
    this.binLocation,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) {
      return null;
    }

    final data = students[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {
        if (binLocation == "") {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Please select bin location!'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        AppNavigator.goToPage(
          context: ctx,
          screen: RawMaterialsToWIPScreen2(
            assignToUser: data.assignToUserid ?? 0,
            created: data.created ?? "",
            id: data.id ?? 0,
            jobOrderNo: data.jobOrderNumber ?? "",
            location: binLocation,
            productId: data.productid ?? 0,
            productName: data.productName ?? "",
            quantity: data.quantity ?? 0,
            transactionDate: data.transactionDate ?? "",
            vendorId: data.vendorId ?? 0,
          ),
        );
      },
      cells: [
        DataCell(SelectableText(
            data.id.toString() == "null" ? "0" : data.id.toString())),
        DataCell(SelectableText(data.assignToUserid.toString() == "null"
            ? "0"
            : data.assignToUserid.toString())),
        DataCell(SelectableText(data.productName ?? "")),
        DataCell(SelectableText(data.quantity.toString() == "null"
            ? "0"
            : data.quantity.toString())),
        DataCell(SelectableText(data.productid.toString() == "null"
            ? "0"
            : data.productid.toString())),
        DataCell(SelectableText(data.jobOrderNumber ?? "")),
        DataCell(SelectableText(data.transactionDate ?? "")),
        DataCell(SelectableText(data.created ?? "")),
        DataCell(SelectableText(data.vendorId.toString() == "null"
            ? "0"
            : data.vendorId.toString())),
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

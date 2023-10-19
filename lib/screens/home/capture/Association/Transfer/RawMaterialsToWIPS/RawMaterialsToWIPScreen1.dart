// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'package:dropdown_search/dropdown_search.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Sales_Order/GetPickingListController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Mapping/Sales_Order/GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel.dart';
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
  List<GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel> table = [];
  List<bool> isMarked = [];

  String? userId;

  void getCurrentUserId() {
    AppPreferences.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserId();

    if (widget.pickedQty != null && widget.pickedQty != "") {
      Future.delayed(
        Duration.zero,
        () {
          AppDialogs.loadingDialog(context);
          GetPickingListController.getAllTable(widget.pickedQty!).then((value) {
            setState(() {
              table = value;
              total = value.length.toString();
              isMarked = List<bool>.filled(value.length, false);
            });
            AppDialogs.closeDialog();
          }).onError(
            (error, stackTrace) {
              AppDialogs.closeDialog();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error.toString().replaceAll("Exception:", ""),
                  ),
                ),
              );
            },
          );
        },
      );
    }
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
                    text: "List of Items in Picklist",
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
                      'po_detail_id',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'po_header_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'assign_to_user_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'vendor_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'purchase_order',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'member_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'create_date',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'supplier_id',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
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
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'price',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'price_subtotal',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'price_total',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'date_order',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'state',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'partner_name',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

  void onClick() async {
    FocusScope.of(context).unfocus();
    AppDialogs.loadingDialog(context);
    GetPickingListController.getAllTable("P00001").then((value) {
      setState(() {
        table = value;
        total = value.length.toString();
        isMarked = List<bool>.filled(value.length, false);
      });
      AppDialogs.closeDialog();
    }).onError(
      (error, stackTrace) {
        setState(() {
          table = [];
          total = "0";
          isMarked = [];
        });
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().replaceAll("Exception:", ""),
            ),
          ),
        );
      },
    );
  }
}

class SourceData extends DataTableSource {
  List<GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel> students;
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

        if (data.quantity == 0 ||
            data.quantity == null ||
            data.state == "Picked") {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Item already picked & ready for dispatch!'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        AppNavigator.goToPage(
          context: ctx,
          screen: RawMaterialsToWIPScreen2(
            id: data.id!,
            poDetailId: data.poDetailId!,
            poHeaderId: data.poHeaderId!,
            assignToUserId: data.assignToUserId!,
            vendorId: data.vendorId!,
            purchaseOrder: data.purchaseOrder!,
            memberId: data.memberId!,
            createDate: data.createDate!,
            supplierId: data.supplierId!,
            productName: data.productName!,
            quantity: data.quantity!,
            price: data.price!,
            priceSubtotal: data.priceSubtotal!,
            priceTotal: data.priceTotal!,
            dateOrder: data.dateOrder!,
            state: data.state!,
            partnerName: data.partnerName!,
            binLocation: binLocation,
          ),
        );
      },
      cells: [
        DataCell(SelectableText(
            data.id.toString() == "null" ? "0" : data.id.toString())),
        DataCell(SelectableText(data.poDetailId.toString() == "null"
            ? "0"
            : data.poDetailId.toString())),
        DataCell(SelectableText(data.poHeaderId.toString() == "null"
            ? "0"
            : data.poHeaderId.toString())),
        DataCell(SelectableText(data.assignToUserId.toString() == "null"
            ? "0"
            : data.assignToUserId.toString())),
        DataCell(SelectableText(data.vendorId.toString() == "null"
            ? "0"
            : data.vendorId.toString())),
        DataCell(SelectableText(data.purchaseOrder ?? "")),
        DataCell(SelectableText(data.memberId.toString() == "null"
            ? "0"
            : data.memberId.toString())),
        DataCell(SelectableText(data.createDate ?? "")),
        DataCell(SelectableText(data.supplierId.toString() == "null"
            ? "0"
            : data.supplierId.toString())),
        DataCell(SelectableText(data.productName ?? "")),
        DataCell(SelectableText(data.quantity.toString() == "null"
            ? "0"
            : data.quantity.toString())),
        DataCell(SelectableText(
            data.price.toString() == "null" ? "0" : data.price.toString())),
        DataCell(SelectableText(data.priceSubtotal.toString() == "null"
            ? "0"
            : data.priceSubtotal.toString())),
        DataCell(SelectableText(data.priceTotal.toString() == "null"
            ? "0"
            : data.priceTotal.toString())),
        DataCell(SelectableText(data.dateOrder ?? "")),
        DataCell(SelectableText(data.state ?? "")),
        DataCell(SelectableText(data.partnerName.toString())),
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

// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'package:dropdown_search/dropdown_search.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/getmapBarcodeDataByItemCodeController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Sales_Order/GetPickingListController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Mapping/Sales_Order/GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Shipping/Sales_Order/PickListAssigned/PickListAssignedScreen2.dart';

// ignore: must_be_immutable
class PickListAssignedScreen extends StatefulWidget {
  String? pickedQty;

  PickListAssignedScreen({this.pickedQty});

  @override
  State<PickListAssignedScreen> createState() => _PickListAssignedScreenState();
}

class _PickListAssignedScreenState extends State<PickListAssignedScreen> {
  final TextEditingController _packingSlipController = TextEditingController();
  String total = "0";
  List<GetSalesPickingListByAssignToUserIdAndPurchaseOrderModel> table = [];
  List<bool> isMarked = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      AppDialogs.loadingDialog(context);
      GetMapBarcodeDataByItemCodeController.getData().then((value) {
        for (int i = 0; i < value.length; i++) {
          setState(() {
            dropDownList.add(value[i].bIN ?? "");
            Set<String> set = dropDownList.toSet();
            dropDownList = set.toList();
          });
        }

        setState(() {
          dropDownValue = dropDownList[0];
          filterList = dropDownList;
        });

        AppDialogs.closeDialog();
      });
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceAll("Exception:", ""),
          ),
        ),
      );
    });

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

  final TextEditingController _searchController = TextEditingController();
  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

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
          title: "Sales Order".toUpperCase(),
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
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Select Location*",
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.73,
                    margin: const EdgeInsets.only(left: 20),
                    child: DropdownSearch<String>(
                      filterFn: (item, filter) {
                        return item
                            .toLowerCase()
                            .contains(filter.toLowerCase());
                      },
                      enabled: true,
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                      items: filterList,
                      onChanged: (value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                      selectedItem: dropDownValue,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        // show dialog box for search
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: TextWidget(
                                text: "Search",
                                color: Colors.blue[900]!,
                                fontSize: 15,
                              ),
                              content: TextFormFieldWidget(
                                controller: _searchController,
                                readOnly: false,
                                hintText: "Enter/Scan Location",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    dropDownList = dropDownList
                                        .where((element) => element
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList();
                                    dropDownValue = dropDownList[0];
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Cancel",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // filter list based on search
                                    setState(() {
                                      filterList = dropDownList
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_searchController.text
                                                  .toLowerCase()))
                                          .toList();
                                      dropDownValue = filterList[0];
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Search",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Packing Slip ID*",
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
                        controller: _packingSlipController,
                        hintText: "Enter/Scan Packing Slip ID",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          onClick();
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
                          onClick();
                        },
                        child: Image.asset(AppImages.finder,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 60,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 1,
                child: PaginatedDataTable(
                  rowsPerPage: 5,
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
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.5,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.grey,
              //       width: 1,
              //     ),
              //   ),
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: DataTable(
              //         showCheckboxColumn: false,
              //         dataRowColor: MaterialStateColor.resolveWith(
              //             (states) => Colors.grey.withOpacity(0.2)),
              //         headingRowColor: MaterialStateColor.resolveWith(
              //             (states) => AppColors.pink),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.grey,
              //             width: 1,
              //           ),
              //         ),
              //         border: TableBorder.all(
              //           color: Colors.black,
              //           width: 1,
              //         ),
              //         columns: const [
              //           DataColumn(
              //               label: Text('ID',
              //                   style: TextStyle(color: Colors.white),
              //                   textAlign: TextAlign.center)),
              //           DataColumn(
              //               label: Text('PICKING ROUTE ID',
              //                   style: TextStyle(color: Colors.white))),
              //           DataColumn(
              //               label: Text('INVENT LOCATION ID',
              //                   style: TextStyle(color: Colors.white))),
              //           DataColumn(
              //               label: Text(
              //             'CONFIG ID',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'ITEM ID',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'ITEM NAME',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'QTY',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'CUSTOMER',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'DLV DATE',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'TRANSREF ID',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'EXP EDITION STATUS',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'DATE TIME ASSIGNED',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'ASSIGNED TOUSER ID',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'PICK STATUS',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //           DataColumn(
              //               label: Text(
              //             'QTY PICKED',
              //             style: TextStyle(color: Colors.white),
              //             textAlign: TextAlign.center,
              //           )),
              //         ],
              //         rows: table.map(
              //           (e) {
              //             return DataRow(
              //               onSelectChanged: (value) {
              //                 if (e.qTY == 0 ||
              //                     e.qTY == null ||
              //                     e.pICKSTATUS == "Picked") {
              //                   ScaffoldMessenger.of(context)
              //                       .showSnackBar(const SnackBar(
              //                     content: Text(
              //                         'Item already picked & ready for dispatch!'),
              //                     duration: Duration(seconds: 2),
              //                   ));
              //                   return;
              //                 }
              //                 AppNavigator.goToPage(
              //                   context: context,
              //                   screen: PickListAssingedScreen2(
              //                     PICKINGROUTEID: e.pICKINGROUTEID.toString(),
              //                     INVENTLOCATIONID:
              //                         e.iNVENTLOCATIONID.toString(),
              //                     CONFIGID: e.cONFIGID.toString(),
              //                     ITEMID: e.iTEMID.toString(),
              //                     ITEMNAME: e.iTEMNAME.toString(),
              //                     QTY: e.qTY.toString(),
              //                     CUSTOMER: e.cUSTOMER.toString(),
              //                     DLVDATE: e.dLVDATE.toString(),
              //                     TRANSREFID: e.tRANSREFID.toString(),
              //                     EXPEDITIONSTATUS:
              //                         e.eXPEDITIONSTATUS.toString(),
              //                     DATETIMEASSIGNED:
              //                         e.dATETIMEASSIGNED.toString(),
              //                     ASSIGNEDTOUSERID:
              //                         e.aSSIGNEDTOUSERID.toString(),
              //                     PICKSTATUS: e.pICKSTATUS.toString(),
              //                     QTYPICKED: e.qTYPICKED == null ? "0" : "0",
              //                   ),
              //                 );
              //               },
              //               cells: [
              //                 DataCell(Text((table.indexOf(e) + 1).toString())),
              //                 DataCell(Text(e.pICKINGROUTEID ?? "")),
              //                 DataCell(Text(e.iNVENTLOCATIONID ?? "")),
              //                 DataCell(Text(e.cONFIGID ?? "")),
              //                 DataCell(Text(e.iTEMID ?? "")),
              //                 DataCell(Text(e.iTEMNAME ?? "")),
              //                 DataCell(Text(e.qTY.toString() == "null"
              //                     ? "0"
              //                     : e.qTY.toString())),
              //                 DataCell(Text(e.cUSTOMER ?? "")),
              //                 DataCell(Text(e.dLVDATE ?? "")),
              //                 DataCell(Text(e.tRANSREFID ?? "")),
              //                 DataCell(Text(
              //                     e.eXPEDITIONSTATUS.toString() == "null"
              //                         ? "0"
              //                         : e.eXPEDITIONSTATUS.toString())),
              //                 DataCell(Text(e.dATETIMEASSIGNED ?? "")),
              //                 DataCell(Text(
              //                     e.aSSIGNEDTOUSERID.toString() == "null"
              //                         ? "0"
              //                         : e.aSSIGNEDTOUSERID.toString())),
              //                 DataCell(Text(e.pICKSTATUS ?? "")),
              //                 DataCell(Text(e.qTYPICKED == null
              //                     ? "0"
              //                     : e.qTYPICKED.toString())),
              //               ],
              //             );
              //           },
              //         ).toList(),
              //       ),
              //     ),
              //   ),
              // ),
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
    GetPickingListController.getAllTable(_packingSlipController.text.trim())
        .then((value) {
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
          screen: PickListAssingedScreen2(
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

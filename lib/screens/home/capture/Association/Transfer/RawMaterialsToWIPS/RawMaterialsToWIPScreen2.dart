// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/getmapBarcodeDataByItemCodeController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/RawMaterialsToWIP/GetMappedBarcodesRMByItemIdAndQtyModel.dart';

// ignore: must_be_immutable
class RawMaterialsToWIPScreen2 extends StatefulWidget {
  num id;
  num assignToUser;
  String productName;
  num quantity;
  num productId;
  String jobOrderNo;
  String transactionDate;
  String created;
  num vendorId;
  String location;

  RawMaterialsToWIPScreen2({
    super.key,
    required this.id,
    required this.assignToUser,
    required this.productName,
    required this.quantity,
    required this.productId,
    required this.jobOrderNo,
    required this.transactionDate,
    required this.created,
    required this.vendorId,
    required this.location,
  });

  @override
  State<RawMaterialsToWIPScreen2> createState() =>
      _RawMaterialsToWIPScreen2State();
}

class _RawMaterialsToWIPScreen2State extends State<RawMaterialsToWIPScreen2> {
  final TextEditingController LocationToController = TextEditingController();
  final TextEditingController _scanItemIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final FocusNode _scanItemIdFocusNode = FocusNode();

  String result = "0";
  List<String> serialNoList = [];
  List<bool> isMarked = [];

  List<GetMappedBarcodesRMByItemIdAndQtyModel> tableList = [];

  @override
  void initState() {
    _quantityController.text = "1";
    super.initState();

    Future.delayed(const Duration(seconds: 1)).then((value) {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scanItemIdController.dispose();
    _quantityController.dispose();
    _scanItemIdFocusNode.dispose();
    LocationToController.dispose();
  }

  final TextEditingController _searchController = TextEditingController();
  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Product ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.productId.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Job Order No.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.jobOrderNo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Bin (FROM)*",
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: const TextWidget(
                        text: "Scan Item ID*",
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, top: 10),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: const TextWidget(
                        text: "Qty*",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: TextFormFieldWidget(
                      controller: _scanItemIdController,
                      hintText: "Enter/Scan Item ID",
                      focusNode: _scanItemIdFocusNode,
                      width: MediaQuery.of(context).size.width * 0.45,
                      onEditingComplete: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: TextFormFieldWidget(
                      controller: _quantityController,
                      hintText: "Qty",
                      width: MediaQuery.of(context).size.width * 0.25,
                      onEditingComplete: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
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
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: PaginatedDataTable(
                  rowsPerPage: 3,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'ID',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Item ID',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Item Name',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Available Qty',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Item Group ID',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: StudentDataSource(
                    tableList,
                    context,
                  ),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Scan Location To*",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: LocationToController,
                  readOnly: false,
                  hintText: "Enter/Scan Location To",
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    // hide keyboard
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Complete",
                  onPressed: () {
                    onInsert();
                  },
                  textColor: Colors.white,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onClick() {
    if (_scanItemIdController.text.trim().isEmpty ||
        _quantityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter item id and quantity"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (int.parse(_quantityController.text.trim()) < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quantity should not be less than 1"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    AppDialogs.loadingDialog(context);
    RawMaterialsToWIPController.getMappedBarcodesRMByItemIdAndQtyController(
      _scanItemIdController.text.trim(),
      int.parse(_quantityController.text.trim()),
    ).then((value) {
      setState(() {
        // if the item id already exists then show snackbar
        if (tableList.any((element) => element.itemId == value.itemId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This Item ID already exists"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        tableList.add(value);

        // focus on item id field
        FocusScope.of(context).requestFocus(_scanItemIdFocusNode);
      });
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceAll("Exception:", ""),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void onInsert() async {
    if (LocationToController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter location"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (tableList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add items"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    AppDialogs.loadingDialog(context);
    RawMaterialsToWIPController.insertItemsLnWIP(
      tableList,
      _scanItemIdController.text.trim().toString(),
      widget.productName.toString(),
      int.parse(widget.quantity.toString()),
      widget.jobOrderNo,
      LocationToController.text.trim().toString(),
    ).then((value) {
      RawMaterialsToWIPController.insertEPCISEvent(
        "Aggregation",
        int.parse(_quantityController.text.trim()),
      ).then((val) {
        setState(() {
          tableList.clear();
          LocationToController.clear();
          _quantityController.text = "1";
          _scanItemIdController.clear();
        });
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Items added successfully"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().replaceAll("Exception:", ""),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceAll("Exception:", ""),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}

class StudentDataSource extends DataTableSource {
  List<GetMappedBarcodesRMByItemIdAndQtyModel> students;
  BuildContext ctx;

  StudentDataSource(
    this.students,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) {
      return null;
    }

    final student = students[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(
            student.id.toString() == "null" ? "0" : student.id.toString())),
        DataCell(SelectableText(student.itemId ?? "")),
        DataCell(SelectableText(student.itemName ?? "")),
        DataCell(SelectableText(student.availableQuantity.toString() == "null"
            ? "0"
            : student.availableQuantity.toString())),
        DataCell(SelectableText(student.itemGroupId ?? "")),
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

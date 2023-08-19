// ignore_for_file: unused_element, avoid_print, sized_box_for_whitespace

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetTblStockMasterByItemIdController.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/UpdateStockMasterDataController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Mapping_Barcode/GetItemInfoByItemSerialNoController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Mapping_Barcode/getAllTblMappedBarcodesController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Mapping_Barcode/insertIntoMappedBarcodeOrUpdateBySerialNoController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/mapping_barcode/GetShipmentReceivedTableModel.dart';
import 'package:gtrack_mobile_app/models/capture/mapping_barcode/getInventTableWMSDataByItemIdOrItemNameModel.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Map<String, dynamic> selectedRow = {};
RxList<dynamic> markedList = [].obs;

class BarcodeMappingScreen extends StatefulWidget {
  @override
  State<BarcodeMappingScreen> createState() => _BarcodeMappingScreenState();
}

class _BarcodeMappingScreenState extends State<BarcodeMappingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _gtinController = TextEditingController();
  final TextEditingController _manufacturingController =
      TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final TextEditingController _binLocationController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  FocusNode focusNode = FocusNode();
  FocusNode serialFocusNode = FocusNode();
  FocusNode gtinFocusNode = FocusNode();

  String? dropDownValue = "Select Config";
  List<String> dropDownList = [
    "Select Config",
    "G",
    "D",
    "S",
    "WG",
    "WD",
    "WS",
    "V",
    "U",
  ];

  String total = "0";

  String userName = "";
  String userID = "";
  String currentDate = "";

  void _showUserInfo() async {
    DateTime now = DateTime.now();
    var formatter = DateFormat.yMd().format(now);

    _manufacturingController.text = formatter;
    currentDate = formatter;
  }

  // a method for showing the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _manufacturingController.text =
            "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
      });
    }
  }

  @override
  void initState() {
    _binLocationController.text = "AZ-W01-Z001-A0001";
    super.initState();
    _showUserInfo();
    _weightController.text = "0";

    print("current date: $currentDate");
  }

  String itemName = '';
  String itemID = '';

  List<getInventTableWMSDataByItemIdOrItemNameModel> itemList = [];
  String dValue = '';
  List<String> dList = [];

  void _onSearchItem() async {
    FocusScope.of(context).unfocus();
    AppDialogs.loadingDialog(context);
    getAllTblMappedBarcodesController
        .getData(_searchController.text.trim())
        .then((value) {
      setState(() {
        itemList = value;
        dList.clear();
        for (var element in itemList) {
          String temp = "${element.iTEMID} - ${element.iTEMNAME}";
          dList.add(temp);
        }
        dValue = dList[0];
      });

      GetTblStockMasterByItemIdController.getData(itemID).then((value) {
        setState(() {
          _widthController.text = value[0].width.toString();
          _heightController.text = value[0].height.toString();
          _lengthController.text = value[0].length.toString();
          _weightController.text = value[0].weight.toString();
        });
        AppDialogs.closeDialog();
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();

        setState(() {
          _widthController.text = "";
          _heightController.text = "";
          _lengthController.text = "";
          _weightController.text = "";
        });
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
        ),
      );
      AppDialogs.closeDialog();
    });
  }

  AwesomeDialog showDiologMethod(
    BuildContext context,
    String title,
    VoidCallback btnOkOnPress,
    VoidCallback btnCancelOnPress,
  ) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: title,
      desc: "Do you want to update the data?",
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: btnCancelOnPress,
      reverseBtnOrder: true,
      // change button text
      btnCancelText: "Cancel",
      btnOkText: "Yes, Update it!",
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            backgroundColor: AppColors.pink,
            autoImplyLeading: true,
            onPressed: () {
              Get.back();
            },
            title: "Barcode Mapping".toUpperCase(),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  AppImages.delete,
                  width: 30,
                  height: 30,
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
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Search Item Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
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
                          hintText: "Search Item No. Or Description",
                          controller: _searchController,
                          width: MediaQuery.of(context).size.width * 0.73,
                          onEditingComplete: () {
                            _onSearchItem();
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
                            _onSearchItem();
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
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonFormField(
                      value: dValue,
                      alignment: Alignment.centerLeft,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      padding: const EdgeInsets.only(top: 7),
                      onChanged: (String? newValue) {
                        setState(() {
                          dValue = newValue!;
                          itemID = itemList
                              .where((element) =>
                                  dValue.contains(element.iTEMID.toString()))
                              .first
                              .iTEMID
                              .toString();
                          itemName = itemList
                              .where((element) =>
                                  dValue.contains(element.iTEMID.toString()))
                              .first
                              .iTEMNAME
                              .toString();
                        });
                      },
                      isExpanded: true,
                      items:
                          dList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            textScaleFactor: 0.7,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              background: null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Text(
                      dValue.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan Serial No",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Serial No",
                    controller: _serialNoController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                      GetItemInfoByItemSerialNoController.getData(
                              _serialNoController.text.trim())
                          .then((value) {
                        if (value == 200) {
                          showDiologMethod(
                            context,
                            "Item Serial No. Already Exists",
                            () {
                              FocusScope.of(context)
                                  .requestFocus(gtinFocusNode);
                            },
                            () {
                              _serialNoController.clear();
                              FocusScope.of(context).requestFocus(focusNode);
                            },
                          ).show();
                        }
                        if (value == 404) {
                          FocusScope.of(context).requestFocus(gtinFocusNode);
                          return;
                        }
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error: $error".replaceAll("Exception:", ""),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        return;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan GTIN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan GTIN",
                    controller: _gtinController,
                    focusNode: gtinFocusNode,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Select Config",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(left: 20),
                  child: DropdownSearch<String>(
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
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Select Manufacture Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "dd/mm/yyyy",
                    controller: _manufacturingController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        size: 30,
                        color: Colors.blue[900]!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan QR Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan QR Code",
                    controller: _qrCodeController,
                    width: MediaQuery.of(context).size.width * 0.9,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Scan Bin Location",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Bin Location",
                    controller: _binLocationController,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Reference",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter/Scan Reference",
                    controller: _referenceController,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Length",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter Length",
                    controller: _lengthController,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Width",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter Width",
                    controller: _widthController,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Height",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter Height",
                    controller: _heightController,
                    textInputAction: TextInputAction.next,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Weight",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextFormFieldWidget(
                    hintText: "Enter Weight",
                    controller: _weightController,
                    textInputAction: TextInputAction.done,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButtonWidget(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    title: "Save",
                    onPressed: () {
                      if (_searchController.text.trim() == "" ||
                          _serialNoController.text.trim() == "" ||
                          _gtinController.text.trim() == "" ||
                          dropDownValue == "Select Config" ||
                          _binLocationController.text.trim() == "" ||
                          _lengthController.text.trim() == "" ||
                          _widthController.text.trim() == "" ||
                          _heightController.text.trim() == "" ||
                          dValue.toString() == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill the above fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      AppDialogs.loadingDialog(context);
                      insertIntoMappedBarcodeOrUpdateBySerialNoController
                          .insert(
                        itemID,
                        itemName,
                        _referenceController.text.trim(),
                        _gtinController.text.trim(),
                        _binLocationController.text.trim(),
                        _serialNoController.text.trim(),
                        dropDownValue.toString(),
                        _qrCodeController.text.trim(),
                        double.parse(_lengthController.text.trim()),
                        double.parse(_widthController.text.trim()),
                        double.parse(_heightController.text.trim()),
                        double.parse(_weightController.text.trim()),
                        _manufacturingController.text.trim(),
                      )
                          .then((value) {
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Data saved successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          // _gtinController.clear();
                          // _binLocationController.clear();
                          _serialNoController.clear();
                          // _manufacturingController.clear();
                          // _qrCodeController.clear();
                          // _referenceController.clear();
                          // _searchController.clear();
                          // _lengthController.clear();
                          // _widthController.clear();
                          // _heightController.clear();
                          // _weightController.clear();

                          // itemID = "";
                          // itemName = "";
                          // itemGroupId = "";
                          // groupName = "";
                        });
                        UpdateStockMasterDataController.insertShipmentData(
                          itemID,
                          double.parse(_lengthController.text.trim()),
                          double.parse(_widthController.text.trim()),
                          double.parse(_heightController.text.trim()),
                          double.parse(_weightController.text.trim()),
                        );
                        FocusScope.of(context).requestFocus(focusNode);
                      }).onError((error, stackTrace) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                error.toString().replaceAll("Exception:", "")),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
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
      ),
    );
  }
}

class StudentDataSource extends DataTableSource {
  List<GetShipmentReceivedTableModel> students;
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
        DataCell(
          Obx(
            () => Checkbox(
              value: markedList[index],
              onChanged: (value) {
                // user can check only one checkbox
                for (int i = 0; i < markedList.length; i++) {
                  markedList[i] = false;
                }
                markedList[index] = value!;
                selectedRow = student.toJson();
              },
            ),
          ),
        ),
        DataCell(SelectableText(student.itemCode ?? "")),
        DataCell(SelectableText(student.itemDesc ?? "")),
        DataCell(SelectableText(student.gTIN ?? "")),
        DataCell(SelectableText(student.remarks ?? "")),
        DataCell(SelectableText(student.user ?? "")),
        DataCell(SelectableText(student.classification ?? "")),
        DataCell(SelectableText(student.mainLocation ?? "")),
        DataCell(SelectableText(student.binLocation ?? "")),
        DataCell(SelectableText(student.intCode ?? "")),
        DataCell(SelectableText(student.itemSerialNo ?? "")),
        DataCell(SelectableText(student.mapDate ?? "")),
        DataCell(SelectableText(student.palletCode ?? "")),
        DataCell(SelectableText(student.reference ?? "")),
        DataCell(SelectableText(student.sID ?? "")),
        DataCell(SelectableText(student.cID ?? "")),
        DataCell(SelectableText(student.pO ?? "")),
        DataCell(SelectableText(student.trans.toString())),
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

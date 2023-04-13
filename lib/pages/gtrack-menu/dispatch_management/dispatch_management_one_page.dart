import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/search_button.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/secondary_button.dart';
import 'package:gtrack_mobile_app/config/common/widgets/text/table_header_text.dart';
import 'package:gtrack_mobile_app/config/common/widgets/text_field/custom_text_field.dart';
import 'package:gtrack_mobile_app/config/common/widgets/text/title_text_widget.dart';
import 'package:gtrack_mobile_app/config/utils/toast.dart';
import 'package:gtrack_mobile_app/domain/services/apis/dispatch_management/dispatch_management_services.dart';
import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/gln_model.dart';
import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/job_order_details_model.dart';
import 'package:gtrack_mobile_app/pages/gtrack-menu/dispatch_management/dispatch_management_two_page.dart';
import 'package:gtrack_mobile_app/providers/dispatch_management/gln_provider.dart';
import 'package:provider/provider.dart';

class DispatchManagementOnePage extends StatefulWidget {
  const DispatchManagementOnePage({super.key});
  static const pageName = '/dispatch-management-one';

  @override
  State<DispatchManagementOnePage> createState() =>
      _DispatchManagementOnePageState();
}

class _DispatchManagementOnePageState extends State<DispatchManagementOnePage> {
  final jobOrderRequestNumberController = TextEditingController();
  final memberIDController = TextEditingController();
  final jobOrderController = TextEditingController();
  final glnidController = TextEditingController();
  final trxDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Job Order details model
  List<JobOrderDetailsModel> jobOrderDetails = [];
  List<GlnModel> glnList = [];

  @override
  void initState() {
    super.initState();
  }

  searchJobOrderDetails() {
    if (jobOrderRequestNumberController.text.isNotEmpty) {
      PrettyToast.success(context, 'Loading');
      DispatchManagementServices.getJobOrderDetails(
        jobOrderRequestNumberController.text,
      ).then((response) {
        setState(() {
          jobOrderDetails = response;
          memberIDController.text = jobOrderDetails[0].memberID.toString();
          jobOrderController.text = jobOrderDetails[0].jobOrderRefNo.toString();
          glnidController.text = jobOrderDetails[0].gLNIDMember.toString();
          trxDateController.text = "";
        });
        PrettyToast.success(context, 'Job Order Details Loaded');
      }).catchError((e) {
        PrettyToast.error(context, e.toString());
      });
    } else {
      PrettyToast.error(context, 'Please enter Job Order Request Number');
    }
  }

  Future<void> startTracking() async {
    if (jobOrderRequestNumberController.text.isNotEmpty) {
      PrettyToast.success(context, 'Loading');
      DispatchManagementServices.getGlnByMemberId(
        memberIDController.text,
      ).then((response) {
        Provider.of<GlnProvider>(context, listen: false).setGlnList(response);
        Get.toNamed(DispatchManagementTwoPage.pageName);
      }).catchError((e) {
        PrettyToast.error(context, e.toString());
      });
    } else {
      PrettyToast.error(context, 'Get Job Order Details first');
    }
  }

  @override
  void dispose() {
    jobOrderRequestNumberController.dispose();
    memberIDController.dispose();
    jobOrderController.dispose();
    glnidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Management'),
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleTextWidget(title: "Job Order Request #"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomTextField(
                          controller: jobOrderRequestNumberController,
                          keyboardType: TextInputType.text,
                          validator: (_) {
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SearchButton(
                          onPressed: () async {
                            await searchJobOrderDetails();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleTextWidget(title: "Member ID"),
                            CustomTextField(
                              controller: memberIDController,
                              enabled: false,
                              validator: (_) {
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleTextWidget(title: "Job Order #"),
                            CustomTextField(
                              enabled: false,
                              controller: jobOrderController,
                              validator: (_) {
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleTextWidget(title: "GLNID"),
                          CustomTextField(
                            enabled: false,
                            controller: glnidController,
                            validator: (_) {
                              return null;
                            },
                          ),
                        ],
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleTextWidget(title: "Trx Date"),
                            CustomTextField(
                              enabled: false,
                              controller: trxDateController,
                              validator: (_) {
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Create a table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return Colors.white;
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        dividerThickness: 2,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        columns: const [
                          DataColumn(
                            label: TableHeaderText(text: 'ItemSKUCode'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'ItemRef2D'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'ItemRefNo'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'ItemBatchNo'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'ItemSerialNo'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'ItemDescription'),
                          ),
                        ],
                        rows: jobOrderDetails
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(e.itemSKUCode.toString())),
                                  DataCell(Text(e.itemRef2D.toString())),
                                  DataCell(Text(e.itemRefNo.toString())),
                                  DataCell(Text(e.itemBatchNo.toString())),
                                  DataCell(Text(e.itemSerialNo.toString())),
                                  DataCell(Text(e.itemDescription.toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: "Cancel",
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PrimaryButton(
                          text: "Start Picking",
                          onPressed: () async {
                            if (memberIDController.text.isNotEmpty) {
                              await startTracking();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

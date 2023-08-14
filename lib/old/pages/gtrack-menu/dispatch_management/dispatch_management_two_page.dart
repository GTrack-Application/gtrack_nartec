import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/components/counter_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/secondary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/drop_down/drop_down_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/title_text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_field_widget.dart';
import 'package:gtrack_mobile_app/old/domain/services/apis/dispatch_management/dispatch_management_services.dart';
import 'package:gtrack_mobile_app/old/domain/services/models/dispatch_management/job_details_model.dart';
import 'package:gtrack_mobile_app/old/providers/dispatch_management/gln_provider.dart';
import 'package:provider/provider.dart';

class DispatchManagementTwoPage extends StatefulWidget {
  const DispatchManagementTwoPage({super.key});
  static const pageName = '/dispatch-management-two';

  @override
  State<DispatchManagementTwoPage> createState() =>
      _DispatchManagementTwoPageState();
}

class _DispatchManagementTwoPageState extends State<DispatchManagementTwoPage> {
  List<String> glnidList = [];
  String glnid = '';
  final scanController = TextEditingController();
  JobDetailsModel? jobDetailsModel;
  final scanGtinFocusNode = FocusNode();
  int quantity = 0;
  bool isClicked = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      glnidList = Provider.of<GlnProvider>(context, listen: false)
          .glnList
          .toSet()
          .toList();
      glnidList = glnidList.map((e) => "(414)$e").toList();
      glnid = glnidList[0];
      setState(() {});
    });
    super.initState();
  }

  scanGTIN() {
    isClicked = true;
    if (scanController.text.isNotEmpty && isClicked) {
      // PrettyToast.success(context, "Loading");
      DispatchManagementServices.getJobDetailsByReferenceNo(scanController.text)
          .then((response) {
        jobDetailsModel = response[0];

        // PrettyToast.success(context, 'Data Loaded');
        setState(() {});
        isClicked = false;
      }).catchError((e) {
        // PrettyToast.error(context, e.toString());
        isClicked = false;
      });
    }
  }

  scanNextItem() {
    isClicked = true;
    if (jobDetailsModel != null && isClicked) {
      // PrettyToast.success(context, "Loading");
      DispatchManagementServices.postTable().then((message) {
        // PrettyToast.success(context, message);
        scanController.clear();
        FocusScope.of(context).requestFocus(scanGtinFocusNode);
        setState(() {});
        isClicked = false;
      }).catchError((e) {
        // PrettyToast.error(context, e.toString());
        isClicked = false;
      });

      jobDetailsModel = null;
    }
  }

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Management'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleTextWidget(title: "GLNID"),
                const SizedBox(height: 8),
                DropDownWidget(
                  items: glnidList,
                  value: glnid,
                  onChanged: (value) {
                    glnid = value!;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                const TitleTextWidget(title: "Scan GTIN"),
                const SizedBox(height: 8),
                TextFieldWidget(
                  controller: scanController,
                  focusNode: scanGtinFocusNode,
                  validator: (_) => null,
                  suffixIcon: ElevatedButton.icon(
                    onPressed: () async {
                      if (scanController.text.isNotEmpty) {
                        await scanGTIN();
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TwoTextWidget(
                        text1: 'Product Name:',
                        text2: jobDetailsModel?.itemDescription ?? '',
                      ),
                      TwoTextWidget(
                        text1: 'Batch:',
                        text2: jobDetailsModel?.itemBatchNo ?? '',
                      ),
                      const TwoTextWidget(
                        text1: 'Expiry:',
                        text2: '',
                      ),
                      TwoTextWidget(
                        text1: 'Serial #:',
                        text2: jobDetailsModel?.itemSerialNo ?? '',
                      ),
                      TwoTextWidget(
                        text1: 'GPC:',
                        text2: jobDetailsModel?.gLNIDMember ?? '',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CounterWidget(
                            quantity: quantity,
                            onPlusPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            onMinusPressed: () {
                              setState(() {
                                if (quantity > 0) {
                                  quantity--;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: PrimaryButtonWidget(
                      text: "Scan Next Item",
                      onPressed: scanNextItem,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TwoTextWidget extends StatelessWidget {
  const TwoTextWidget({
    super.key,
    required this.text1,
    required this.text2,
  });

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    // return table row
    return Table(
      children: [
        TableRow(
          children: [
            Text(
              text1,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text2,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

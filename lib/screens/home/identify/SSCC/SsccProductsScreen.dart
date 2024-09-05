// ignore_for_file: file_names, unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/sscc/sscc_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/sscc/sscc_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/SSCC/SsccModel.dart';
import 'package:gtrack_mobile_app/screens/home/identify/SSCC/add_sscc_screen.dart';
import 'package:gtrack_mobile_app/screens/home/identify/SSCC/sscc_cubit/sscc_cubit.dart';
import 'package:gtrack_mobile_app/screens/home/identify/SSCC/sscc_cubit/sscc_state.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class SsccProductsScreen extends StatefulWidget {
  const SsccProductsScreen({super.key});

  @override
  State<SsccProductsScreen> createState() => _SsccProductsScreenState();
}

class _SsccProductsScreenState extends State<SsccProductsScreen> {
  String total = "0";
  List<bool> isMarked = [];
  List<SsccModel> table = [];

  TextEditingController searchController = TextEditingController();

  String? userId, gcp, memberCategoryDescription;

  @override
  void initState() {
    super.initState();

    AppPreferences.getMemberId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);

    BlocProvider.of<SsccCubit>(context).getSsccData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void _showBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BarcodeDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "SSCC Products".toUpperCase(),
        ),
        backgroundColor: AppColors.skyBlue,
      ),
      body: BlocConsumer<SsccCubit, SsccState>(
        bloc: BlocProvider.of<SsccCubit>(context),
        listener: (context, state) {
          if (state is SsccErrorState) {
          } else if (state is SsccLoadedState) {
            if (state.data.isEmpty) {
              toast("No data found for this user.");
            }
            table = state.data;
          } else if (state is SsccDeleted) {
            BlocProvider.of<SsccCubit>(context).getSsccData();
            toast("SSCC Item deleted successfully.");
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<SsccCubit>(context).getSsccData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Member ID",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              userId ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            AppNavigator.goToPage(
                              context: context,
                              screen: const AddSsccFormScreen(),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200]!,
                            foregroundColor: Colors.green[700]!,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Add SSCC",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _showBarcodeDialog(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200]!,
                            foregroundColor: Colors.green[700]!,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Bulk SSCC",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Ionicons.search_outline),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SSCC List",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Ionicons.filter_outline,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  state is SsccLoadingState
                      ? Shimmer.fromColors(
                          baseColor: AppColors.grey,
                          highlightColor: AppColors.white,
                          child: Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              color: Colors.black38,
                            ),
                          ),
                        )
                      : state is SsccLoadedState
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: table.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    movementDuration:
                                        const Duration(seconds: 1),
                                    secondaryBackground: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Swipe to Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          10.width,
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    background: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Swipe to Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                          10.width,
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Are you sure?"),
                                          content: const Text(
                                              "Do you want to delete this product?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                BlocProvider.of<SsccCubit>(
                                                        context)
                                                    .deleteSscc(table[index]
                                                        .id
                                                        .toString());

                                                BlocProvider.of<SsccCubit>(
                                                        context)
                                                    .getSsccData();
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text("No"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (direction) {
                                      BlocProvider.of<SsccCubit>(context)
                                          .deleteSscc(
                                              table[index].id.toString());
                                    },
                                    child: Container(
                                      width: context.width() * 0.9,
                                      height: 50,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5, bottom: 5, top: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.skyBlue),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${index + 1}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              table[index].ssccType ?? "",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              table[index].sSCCBarcodeNumber ??
                                                  "",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BarcodeDialog extends StatefulWidget {
  const BarcodeDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BarcodeDialogState createState() => _BarcodeDialogState();
}

class _BarcodeDialogState extends State<BarcodeDialog> {
  final List<int> extensionDigits = List<int>.generate(10, (i) => i); // 0 to 9
  int? selectedExtensionDigit;
  final TextEditingController _quantityController = TextEditingController();

  SSCCCubit ssccCubit = SSCCCubit();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Generate Bulk SSCC Barcodes',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ), // Adjusted title size
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Extension Digit',
                border: OutlineInputBorder(),
              ),
              value: selectedExtensionDigit,
              onChanged: (int? newValue) {
                setState(() {
                  selectedExtensionDigit = newValue;
                });
              },
              items: extensionDigits.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Close'),
        ),
        BlocConsumer<SSCCCubit, SSCCState>(
          bloc: ssccCubit,
          listener: (context, state) {
            if (state is SsccError) {
              Navigator.of(context).pop();
              toast(state.error);
            }
            if (state is SsccLoaded) {
              BlocProvider.of<SsccCubit>(context).getSsccData();
              Navigator.of(context).pop();
              toast("Bulk SSCC generated successfully.");
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                print('Extension Digit: $selectedExtensionDigit');
                print('Quantity: ${_quantityController.text}');

                if (selectedExtensionDigit == null ||
                    _quantityController.text.isEmpty) {
                  toast("Please select extension digit and enter quantity.");
                  return;
                }

                ssccCubit.postSsccBulk(
                  selectedExtensionDigit.toString(),
                  int.parse(_quantityController.text.trim()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: state is SsccLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Text('Generate'),
            );
          },
        ),
      ],
    );
  }
}

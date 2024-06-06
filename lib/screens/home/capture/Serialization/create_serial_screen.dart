// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/serialization_gtin_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateSerialScreen extends StatefulWidget {
  final GTIN_Model gtin;
  const CreateSerialScreen({super.key, required this.gtin});

  @override
  State<CreateSerialScreen> createState() => _CreateSerialScreenState();
}

class _CreateSerialScreenState extends State<CreateSerialScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Serials'),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.background,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: widget.gtin == ""
            ? const Center(
                child: Text("Please scan GTIN first to create serials"),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FieldWidget(
                          labelText: "Quantity",
                          onChanged: (p0) {
                            CaptureCubit.get(context).quantity = int.parse(p0);
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Batch Number",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FieldWidget(
                          labelText: "Batch Number",
                          onChanged: (p0) {
                            CaptureCubit.get(context).batchNumber = p0;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Expiry Date",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FieldWidget(
                          controller: CaptureCubit.get(context).expiryDate,
                          labelText: "Expiry Date",
                          readOnly: true,
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await CaptureCubit.get(context)
                                  .setExpiryDate(context);
                              setState(() {});
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Manufacturing Date",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        FieldWidget(
                          controller:
                              CaptureCubit.get(context).manufacturingDate,
                          labelText: "Manufacturing Date",
                          readOnly: true,
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await CaptureCubit.get(context)
                                  .setManufacturingDate(context);
                              setState(() {});
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                    50.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocConsumer<CaptureCubit, CaptureState>(
                          listener: (context, state) {
                            if (state is CaptureCreateSerializationSuccess) {
                              toast("Serials created successfully");
                              CaptureCubit.get(context).getSerializationData(
                                  widget.gtin.barcode ?? "");
                              AppNavigator.replaceTo(
                                  context: context,
                                  screen: SerializationGtinScreen(
                                    gtinModel: widget.gtin,
                                  ));
                            } else if (state
                                is CaptureCreateSerializationError) {
                              toast(state.message);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                CaptureCubit.get(context)
                                    .createNewSerial(widget.gtin.barcode ?? "");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pink,
                                foregroundColor: AppColors.white,
                              ),
                              child: state is CaptureCreateSerializationLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.white))
                                  : const Text(
                                      "Create Serials",
                                      style: TextStyle(
                                        color: AppColors.background,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class FieldWidget extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final bool? readOnly;
  const FieldWidget({
    super.key,
    this.labelText,
    this.controller,
    this.suffixIcon,
    this.onChanged,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: AppColors.grey,
        // ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          // labelText: labelText ?? '',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.background,
          filled: true,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

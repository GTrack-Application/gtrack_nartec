import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';

class CreateSerialScreen extends StatefulWidget {
  final String gtin;
  const CreateSerialScreen({super.key, required this.gtin});

  @override
  State<CreateSerialScreen> createState() => _CreateSerialScreenState();
}

class _CreateSerialScreenState extends State<CreateSerialScreen> {
  @override
  void initState() {
    super.initState();
    print(CaptureCubit.get(context).gtin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Serials'),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.gtin == ""
              ? const Center(
                  child: Text("Please scan GTIN first to create serials"),
                )
              : Column(
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    FieldWidget(
                      controller: CaptureCubit.get(context).manufacturingDate,
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
                    // const Spacer(),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocConsumer<CaptureCubit, CaptureState>(
                          listener: (context, state) {
                            if (state is CaptureCreateSerializationSuccess) {
                              AppSnackbars.success(context, state.message, 3);
                              Navigator.pop(context);
                            } else if (state
                                is CaptureCreateSerializationError) {
                              AppSnackbars.danger(context, state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is CaptureCreateSerializationLoading) {
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () {
                                CaptureCubit.get(context).createNewSerial(
                                  widget.gtin,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pink,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text(
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
      height: 50,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: AppColors.grey,
        // ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
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

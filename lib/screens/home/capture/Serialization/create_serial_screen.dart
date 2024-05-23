import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';

class CreateSerialScreen extends StatefulWidget {
  const CreateSerialScreen({super.key});

  @override
  State<CreateSerialScreen> createState() => _CreateSerialScreenState();
}

class _CreateSerialScreenState extends State<CreateSerialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Serials'),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CaptureCubit.get(context).gtin == ""
            ? const Center(
                child: Text("Please scan GTIN first"),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  FieldWidget(
                    controller: CaptureCubit.get(context).expiryDate,
                    labelText: "Expiry Date",
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        await CaptureCubit.get(context).setExpiryDate(context);
                        setState(() {});
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Manufecturing Date",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  FieldWidget(
                    controller: CaptureCubit.get(context).manufacturingDate,
                    labelText: "Manufecturing Date",
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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocConsumer<CaptureCubit, CaptureState>(
                        listener: (context, state) {
                          if (state is CaptureCreateSerializationSuccess) {
                            AppSnackbars.success(context, state.message, 3);
                            Navigator.pop(context);
                          } else if (state is CaptureCreateSerializationError) {
                            print(state.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is CaptureCreateSerializationLoading) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: () {
                              CaptureCubit.get(context).createNewSerial();
                            },
                            child: const Text("Create Serials"),
                          );
                        },
                      ),
                    ],
                  ),
                ],
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
          labelText: labelText ?? '',
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

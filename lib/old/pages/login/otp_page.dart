// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_toast.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/icon_text_field.dart';
import 'package:gtrack_mobile_app/old/domain/services/apis/login/login_services.dart';
import 'package:gtrack_mobile_app/screens/home/Home_screen.dart';

class OtpPage extends StatefulWidget {
  final String email, activity, password, generatedOtp, activityId;
  const OtpPage({
    super.key,
    required this.email,
    required this.activity,
    required this.password,
    required this.generatedOtp,
    required this.activityId,
  });
  static const String pageName = '/otp';

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  @override
  void initState() {
    formKey.currentState?.save();
    Future.delayed(const Duration(microseconds: 500), () async {
      try {
        otpController.text = widget.generatedOtp;
      } catch (e) {
        AppToast.danger(e.toString());
      }
    });
    super.initState();
  }

  verifyOtp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      try {
        AppDialogs.loadingDialog(context);
        await LoginServices.confirmation(
          context,
          widget.email.toString(),
          widget.activity.toString(),
          widget.activityId,
          widget.password.toString(),
          widget.generatedOtp.toString(),
          otpController.text,
        );
        AppDialogs.closeDialog();

        // Get.toNamed(MenuPage.pageName);
        AppNavigator.replaceTo(context: context, screen: const HomeScreen());
      } catch (e) {
        AppDialogs.closeDialog();
        AppToast.danger(e.toString());
      }
    }
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(AppImages.logo),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter the OTP sent to you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconTextField(
                  controller: otpController,
                  leadingIcon: Image.asset(AppIcons.work),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The field is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButtonWidget(text: "Verify OTP", onPressed: verifyOtp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

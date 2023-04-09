import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/custom_text_field.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';
import 'package:gtrack_mobile_app/domain/services/login/login_services.dart';
import 'package:gtrack_mobile_app/pages/gtrack-menu/menu_page.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});
  static const String pageName = '/otp';

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  String? generatedOtp;

  @override
  void initState() {
    formKey.currentState?.save();
    Future.delayed(const Duration(microseconds: 500), () async {
      final email = Provider.of<LoginProvider>(context, listen: false).email;
      final activity =
          Provider.of<LoginProvider>(context, listen: false).activity;

      try {
        final response = await LoginServices.sendOTP(
          email.toString(),
          activity.toString(),
        );

        Fluttertoast.showToast(
          msg: response["message"],
          backgroundColor: Colors.blue,
        );
        generatedOtp = response["otp"];
        otpController.text = response["otp"];
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          Navigator.pop(context);
        });
      }
    });
    super.initState();
  }

  verifyOtp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      final email = Provider.of<LoginProvider>(context, listen: false).email;
      final activity =
          Provider.of<LoginProvider>(context, listen: false).activity;
      final password =
          Provider.of<LoginProvider>(context, listen: false).password;
      try {
        await LoginServices.confirmation(
          email.toString(),
          activity.toString(),
          password.toString(),
          generatedOtp.toString(),
          otpController.text,
        );

        Get.toNamed(MenuPage.pageName);
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(Images.logo),
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
              CustomTextField(
                emailController: otpController,
                leadingIcon: Image.asset(CustomIcons.work),
                width: double.infinity,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "The field is required";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    await verifyOtp();
                  },
                  child: const Text('Verify Now')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/config/common/widgets/text_field/icon_text_field.dart';
import 'package:gtrack_mobile_app/config/utils/custom_dialog.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';
import 'package:gtrack_mobile_app/domain/services/apis/login/login_services.dart';
import 'package:gtrack_mobile_app/pages/login/otp_page.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ActivitiesAndPasswordPage extends StatefulWidget {
  const ActivitiesAndPasswordPage({super.key});
  static const String pageName = '/activitiesAndPassword';

  @override
  State<ActivitiesAndPasswordPage> createState() =>
      _ActivitiesAndPasswordPageState();
}

class _ActivitiesAndPasswordPageState extends State<ActivitiesAndPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  List<String> activities = [];
  String? activityValue;
  String email = '';

  showOtpPopup(
    String message, {
    String? email,
    String? activity,
    String? password,
  }) {
    CustomDialog.success(
      context,
      title: "OTP",
      desc: message,
      btnOkOnPress: () {
        email = Provider.of<LoginProvider>(context, listen: false).email;
        activity = Provider.of<LoginProvider>(context, listen: false).activity;
        Get.toNamed(OtpPage.pageName);
      },
    );
  }

  login() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      if (activityValue != null && passwordController.text.isNotEmpty) {
        Provider.of<LoginProvider>(context, listen: false)
            .setActivity(activityValue.toString());
        Provider.of<LoginProvider>(context, listen: false)
            .setPassword(passwordController.text);
        email =
            Provider.of<LoginProvider>(context, listen: false).email.toString();
        final activity = Provider.of<LoginProvider>(context, listen: false)
            .activity
            .toString();

        LoginServices.loginWithPassword(
          email,
          activity.toString(),
          passwordController.text,
        ).then((value) {
          final message = value['message'] as String;

          showOtpPopup(
            message,
            email: email,
            activity: activityValue,
            password: passwordController.text,
          );
        }).onError((error, stackTrace) {
          if (error.toString() == 'Exception: Please Wait For Admin Approval') {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.rightSlide,
              title: 'Message',
              desc: error.toString().replaceFirst('Exception:', ""),
              btnOkOnPress: () {},
            ).show();
          }
        });
      } else {
        CustomDialog.error(context);
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listOfAcitivies =
        Provider.of<LoginProvider>(context, listen: false).activities;

    final activities = listOfAcitivies!
        .where((activity) => activity != null)
        .map((e) => e.toString())
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    Images.logo,
                    width: 189,
                    height: 189,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: const Text('Select your activity'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Image.asset(CustomIcons.work, width: 42, height: 42),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FittedBox(
                              child: SizedBox(
                                height: 100,
                                child: Card(
                                  elevation: 5,
                                  child: DropdownButton(
                                      value: activityValue,
                                      items: activities
                                          .where(
                                              (element) => element.isNotEmpty)
                                          .map<DropdownMenuItem<String>>(
                                            (String v) =>
                                                DropdownMenuItem<String>(
                                              value: v,
                                              child: FittedBox(child: Text(v)),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          activityValue = newValue!;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: const Text('Enter your password'),
                    ),
                    IconTextField(
                      controller: passwordController,
                      leadingIcon: Image.asset(
                        CustomIcons.passwordIcon,
                        width: 42,
                        height: 42,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Forgot password?'),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Click here',
                              style: TextStyle(
                                // make it underline
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: PrimaryButton(
                  onPressed: login,
                  text: "Log in",
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

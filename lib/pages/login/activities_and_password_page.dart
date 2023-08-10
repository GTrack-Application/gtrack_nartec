import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/constants/app_text_styles.dart';
import 'package:gtrack_mobile_app/domain/services/apis/login/login_services.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/custom_dialog.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/drop_down/drop_down_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/icon_text_field.dart';
import 'package:gtrack_mobile_app/models/activities/email_activities_model.dart';
import 'package:gtrack_mobile_app/pages/login/otp_page.dart';
import 'package:velocity_x/velocity_x.dart';

class ActivitiesAndPasswordPage extends StatefulWidget {
  final String email;
  final List<EmailActivitiesModel>? activities;
  const ActivitiesAndPasswordPage(
      {super.key, required this.email, this.activities});
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

  @override
  void initState() {
    super.initState();
    widget.activities?.forEach((element) {
      if (element.activity != "null" || element.activity != null) {
        activities.add(element.activity!);
      }
    });
    activityValue = activities[0];
  }

  showOtpPopup(
    String message, {
    String? email,
    String? activity,
    String? password,
    String? generatedOtp,
  }) {
    CustomDialog.success(
      context,
      title: "OTP",
      desc: message,
      btnOkOnPress: () {
        AppNavigator.goToPage(
          context: context,
          screen: OtpPage(
            email: email.toString(),
            activity: activity.toString(),
            password: password.toString(),
            generatedOtp: generatedOtp.toString(),
          ),
        );
      },
    );
  }

  login() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      if (activityValue != null && passwordController.text.isNotEmpty) {
        AppDialogs.loadingDialog(context);

        LoginServices.loginWithPassword(
          widget.email,
          activityValue!,
          passwordController.text.trim(),
        ).then((value) {
          AppDialogs.closeDialog();
          final message = value['message'] as String;
          final generatedOtp = value['otp'] as String;

          showOtpPopup(
            message,
            email: widget.email,
            activity: activityValue,
            password: passwordController.text,
            generatedOtp: generatedOtp,
          );
        }).onError((error, stackTrace) {
          AppDialogs.closeDialog();
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
                    AppImages.logo,
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
                    // Container(
                    //   margin: const EdgeInsets.only(left: 60),
                    //   child: const Text('Select your activity'),
                    // ),
                    Text(
                      "Select your activity",
                      style: AppTextStyle.titleStyle,
                    ),
                    Row(
                      children: [
                        Image.asset(AppIcons.work, width: 42, height: 42),
                        const SizedBox(width: 10),
                        Flexible(
                          child: DropDownWidget(
                            items: activities,
                            value: activityValue ?? activities[0],
                            onChanged: (activity) {
                              setState(() {
                                activityValue = activity.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 60),
                    //   child: const Text('Enter your password'),
                    // ),
                    Text(
                      "Enter your password",
                      style: AppTextStyle.titleStyle,
                    ),
                    IconTextField(
                      controller: passwordController,
                      leadingIcon: Image.asset(
                        AppIcons.passwordIcon,
                        width: 42,
                        height: 42,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              PrimaryButtonWidget(
                onPressed: login,
                text: "Log in",
              ).box.width(context.width * 0.85).makeCentered(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

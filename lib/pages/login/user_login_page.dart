import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_text_styles.dart';
import 'package:gtrack_mobile_app/domain/services/apis/login/login_services.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/components/app_logo.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/icon_text_field.dart';
import 'package:gtrack_mobile_app/pages/login/activities_and_password_page.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});
  static const String pageName = '/login';

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  login() {
    if (formKey.currentState?.validate() ?? false) {
      AppDialogs.loadingDialog(context);
      LoginServices.login(email: emailController.text).then((response) {
        AppDialogs.closeDialog();
        final activities = response;

        // add email and activities to login provider
        Provider.of<LoginProvider>(context, listen: false)
            .setEmail(emailController.text);
        Provider.of<LoginProvider>(context, listen: false)
            .setActivities(activities);

        AppNavigator.goToPage(
          context: context,
          screen: ActivitiesAndPasswordPage(
            email: emailController.text.trim(),
            activities: activities,
          ),
        );
        // Get.toNamed(
        //   ActivitiesAndPasswordPage.pageName,
        //   arguments: activities,
        //   parameters: {
        //     'email': emailController.text,
        //   },
        // );
      }).catchError((error) {
        AppDialogs.closeDialog();
        AppSnackbars.danger(context, error.toString());
      });
    }
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
            children: [
              const AppLogo(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter your login ID',
                          style: AppTextStyle.titleStyle,
                        ),
                        IconTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          leadingIcon: Image.asset(
                            AppIcons.usernameIcon,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your login ID';
                            }
                            if (EmailValidator.validate(value)) {
                              return null;
                            } else {
                              return 'Please enter a valid email';
                            }
                          },
                        ).box.width(context.width * 0.9).make(),
                        const SizedBox(height: 20),
                      ],
                    ),
                    PrimaryButtonWidget(
                      onPressed: login,
                      text: "Log in",
                    ).box.width(context.width * 0.85).makeCentered(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

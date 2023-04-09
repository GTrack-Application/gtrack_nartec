import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/buttons/custom_elevated_button.dart';
import 'package:gtrack_mobile_app/config/common/widgets/custom_text_field.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';
import 'package:gtrack_mobile_app/domain/services/login/login_services.dart';
import 'package:gtrack_mobile_app/pages/login/activities_and_password_page.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:provider/provider.dart';

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
      Fluttertoast.showToast(
        msg: 'Login in progress...',
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 5,
        backgroundColor: Theme.of(context).primaryColor,
      );
      LoginServices.login(email: emailController.text).then((response) {
        final activities = response['activities'] as List<dynamic>;

        // add email and activities to login provider
        Provider.of<LoginProvider>(context, listen: false)
            .setEmail(emailController.text);
        Provider.of<LoginProvider>(context, listen: false)
            .setActivities(activities);

        Get.toNamed(
          ActivitiesAndPasswordPage.pageName,
          arguments: activities,
          parameters: {
            'email': emailController.text,
          },
        );
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.redAccent,
        );
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(
          msg: error.toString(),
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.redAccent,
        );
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
                padding: EdgeInsets.only(
                  left: 22,
                  right: MediaQuery.of(context).size.width * 0.23,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: const Text('Enter your login ID'),
                    ),
                    CustomTextField(
                      emailController: emailController,
                      keyboardType: TextInputType.emailAddress,
                      width: MediaQuery.of(context).size.width * 0.7,
                      leadingIcon: Image.asset(
                        CustomIcons.usernameIcon,
                        width: 42,
                        height: 42,
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
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: CustomElevatedButton(
                  onPressed: login,
                  text: "Log in",
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

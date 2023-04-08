import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/common/widgets/custom_text_field.dart';
import 'package:gtrack_mobile_app/config/utils/icons.dart';
import 'package:gtrack_mobile_app/config/utils/images.dart';
import 'package:gtrack_mobile_app/pages/gtrack-menu/menu_page.dart';

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
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      child: const Text('Enter your password'),
                    ),
                    CustomTextField(
                      emailController: passwordController,
                      leadingIcon: Image.asset(
                        CustomIcons.passwordIcon,
                        width: 42,
                        height: 42,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText,
                      width: MediaQuery.of(context).size.width * 0.7,
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
                  child: CustomElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    MenuPage.pageName,
                    preventDuplicates: true,
                  );
                },
                text: "Log in",
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.text,
    this.margin,
  });

  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ??
          EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.23,
            right: MediaQuery.of(context).size.width * 0.23,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        child: Text(
          text ?? "Text",
        ),
      ),
    );
  }
}

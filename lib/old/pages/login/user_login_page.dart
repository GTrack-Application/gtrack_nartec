import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/components/app_logo.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/drop_down/drop_down_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/icon_text_field.dart';
import 'package:gtrack_mobile_app/old/domain/services/apis/login/login_services.dart';
import 'package:gtrack_mobile_app/old/pages/login/activities_and_password_page.dart';
import 'package:gtrack_mobile_app/old/providers/login/login_provider.dart';
import 'package:gtrack_mobile_app/screens/home_screen.dart';
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

        AppPreferences.setCurrentUser(currentUser).then((_) {});

        AppNavigator.goToPage(
          context: context,
          screen: ActivitiesAndPasswordPage(
            email: emailController.text.trim(),
            activities: activities,
          ),
        );
      }).catchError((error) {
        AppDialogs.closeDialog();
        AppSnackbars.danger(context, error.toString());
      });
    }
  }

  brandOwnerLogin() async {
    AppDialogs.loadingDialog(context);
    LoginServices.brandOwnerLogin(
      emailController.text.trim(),
      passwordController.text.trim(),
    ).then((value) {
      AppPreferences.setToken(value.token.toString()).then((_) {});
      AppPreferences.setUserId(value.data!.userID.toString()).then((_) {});
      AppPreferences.setNormalUserId(emailController.text.trim().toString())
          .then((_) {});
      AppPreferences.setCurrentUser(currentUser).then((_) {});

      AppDialogs.closeDialog();
      AppSnackbars.success(context, "Login Successful", 2);
      AppNavigator.replaceTo(context: context, screen: const HomeScreen());
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(context, error.toString());
    });
  }

  supplierOwnerLogin() async {
    AppDialogs.loadingDialog(context);
    LoginServices.supplierLogin(
      emailController.text.trim(),
      passwordController.text.trim(),
    ).then((value) {
      AppPreferences.setToken(value.token.toString()).then((_) {});
      AppPreferences.setUserId(value.data!.userId.toString()).then((_) {});
      AppPreferences.setNormalUserId(emailController.text.trim().toString())
          .then((_) {});
      AppPreferences.setCurrentUser(currentUser).then((_) {});
      AppPreferences.setVendorId(value.data!.vendorId.toString()).then((_) {});

      AppDialogs.closeDialog();
      AppSnackbars.success(context, "Login Successful", 2);
      AppNavigator.replaceTo(context: context, screen: const HomeScreen());
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(context, error.toString());
    });
  }

  String currentUser = "";

  String dropdownValue = "Admin User";
  List<String> dropdownList = [
    "Admin User",
    "Normal User",
  ];

  String stakeHolderValue = "Brand Owner";
  List<String> stakeHolderList = [
    "Brand Owner",
    "Manufacturer",
    "Supplier",
    "Distributor",
    "Retailer",
    "Local Authority",
  ];

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(width: 180, height: 180),
                const SizedBox(height: 20),
                const Text(
                  'User Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                  ),
                ),
                DropDownWidget(
                  items: dropdownList,
                  value: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                      if (dropdownValue == "Admin User") {
                        currentUser = "Admin";
                      }
                      emailController.clear();
                      passwordController.clear();
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your login ID',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                  ),
                ),
                IconTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  leadingIcon: Image.asset(AppIcons.usernameIcon),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your login ID';
                    }
                    // if (EmailValidator.validate(value)) {
                    //   return null;
                    // } else {
                    //   return 'Please enter a valid email';
                    // }
                    return null;
                  },
                ).box.width(context.width * 0.9).make(),
                const SizedBox(height: 20),
                Visibility(
                  visible: dropdownValue == "Admin User" ? false : true,
                  child: const Text(
                    "Enter your password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                Visibility(
                  visible: dropdownValue == "Admin User" ? false : true,
                  child: IconTextField(
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
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: dropdownValue == "Admin User" ? false : true,
                  child: const Text(
                    'Stakeholder\'s Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                Visibility(
                  visible: dropdownValue == "Admin User" ? false : true,
                  child: DropDownWidget(
                    items: stakeHolderList,
                    value: stakeHolderValue,
                    onChanged: (value) {
                      setState(() {
                        stakeHolderValue = value!;
                        currentUser = stakeHolderValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButtonWidget(
                  onPressed: () {
                    if (dropdownValue.toString() == "Normal User") {
                      if (stakeHolderValue == "Brand Owner") {
                        brandOwnerLogin();
                        return;
                      }
                      if (stakeHolderValue == "Supplier") {
                        supplierOwnerLogin();
                        return;
                      }
                    }

                    if (dropdownValue.toString() == "Admin User") {
                      login();
                      return;
                    }
                  },
                  text: "Log in",
                ).box.width(context.width * 0.85).makeCentered(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

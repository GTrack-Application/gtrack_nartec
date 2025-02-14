// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/controllers/auth/auth_controller.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/drop_down/drop_down_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
import 'package:gtrack_nartec/screens/home/auth/services/login_services.dart';
import 'package:gtrack_nartec/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController adminPasswordController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode adminPasswordNode = FocusNode();
  bool obscureText = true;

  // a method that deletes all the data from the sharedpreferences
  void clearData() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        clearData();
      },
    );
  }

  @override
  void dispose() {
    //controllers
    emailController.dispose();
    passwordController.dispose();
    adminPasswordController.dispose();
    formKey.currentState?.dispose();

    //focus nodes
    emailNode.dispose();
    passwordNode.dispose();
    adminPasswordNode.dispose();
    super.dispose();
  }

  // login() {
  //   if (formKey.currentState?.validate() ?? false) {
  //     AppDialogs.loadingDialog(context);
  //     LoginServices.login(email: emailController.text).then((response) {
  //       AppDialogs.closeDialog();
  //       final activities = response;

  //       // add email and activities to login provider
  //       Provider.of<LoginProvider>(context, listen: false)
  //           .setEmail(emailController.text);
  //       Provider.of<LoginProvider>(context, listen: false)
  //           .setActivities(activities);

  //       AppPreferences.setCurrentUser("Admin").then((_) {});

  //       AppNavigator.goToPage(
  //         context: context,
  //         screen: ActivitiesAndPasswordPage(
  //           email: emailController.text.trim(),
  //           activities: activities,
  //         ),
  //       );
  //     }).catchError((error) {
  //       AppDialogs.closeDialog();
  //       AppSnackbars.danger(context, error.toString());
  //     });
  //   }
  // }

  login() async {
    if (formKey.currentState?.validate() ?? false) {
      AppDialogs.loadingDialog(context);
      await AuthController.loginWithPassword(
        emailController.text.trim(),
        adminPasswordController.text.trim(),
      ).then((value) {
        AppPreferences.setToken(value.token.toString()).then((_) {});
        AppPreferences.setUserId(value.user!.id.toString()).then((_) {});
        AppPreferences.setCurrentUser("Admin User").then((_) {});
        AppPreferences.setGln(value.user!.gln.toString()).then((_) {});
        AppPreferences.setId(value.user!.id.toString()).then((_) {});

        AppDialogs.closeDialog();
        AppNavigator.goToPage(context: context, screen: const HomeScreen());
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        AppSnackbars.danger(
          context,
          error.toString().replaceAll("Exeption", ""),
        );
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
      AppPreferences.setCurrentUser("Brand Owner").then((_) {});

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
      AppPreferences.setCurrentUser("Supplier").then((_) {});
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

  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/trans_logo.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const Text(
                    'User Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFieldWidget(
                    hintText: "Login ID",
                    controller: emailController,
                    focusNode: emailNode,
                    keyboardType: TextInputType.emailAddress,
                    leadingIcon: Image.asset(AppIcons.usernameIcon),
                    onFieldSubmitted: (p0) {
                      if (dropdownValue == "Admin User") {
                        // hide the keyboard
                        emailNode.unfocus();
                        FocusScope.of(context).requestFocus(adminPasswordNode);
                      } else {
                        // scope to password node
                        FocusScope.of(context).requestFocus(passwordNode);
                      }
                    },
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
                  ),
                  // .box.width(context.width * 0.9).make(),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: dropdownValue == "Admin User" ? true : false,
                    child: TextFieldWidget(
                      hintText: "Password",
                      focusNode: adminPasswordNode,
                      onFieldSubmitted: (p0) {
                        // hide keyboard
                        adminPasswordNode.unfocus();
                      },
                      controller: adminPasswordController,
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
                  Visibility(
                    visible: dropdownValue == "Admin User" ? false : true,
                    child: TextFieldWidget(
                      hintText: "Password",
                      focusNode: passwordNode,
                      onFieldSubmitted: (p0) {
                        // hide keyboard
                        passwordNode.unfocus();
                      },
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
                  const SizedBox(height: 20),
                  Visibility(
                    visible: dropdownValue == "Admin User" ? false : true,
                    child: const Text(
                      'Stakeholder Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
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
                    backgroungColor: const Color(0xFF4200FF),
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
                    text: "Login Now",
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              fillColor: WidgetStateProperty.all(Colors.white),
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            const Text(
                              'Remember Me',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Need Help?',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

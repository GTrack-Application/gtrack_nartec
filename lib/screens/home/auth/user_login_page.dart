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
  // Form key and controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adminPasswordController =
      TextEditingController();

  // Focus nodes
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _adminPasswordNode = FocusNode();

  // UI state
  bool _obscureText = true;
  bool _rememberMe = false;
  String _currentUser = "";

  // Dropdown values
  String _userTypeValue = "Admin User";
  final List<String> _userTypeList = ["Admin User", "Normal User"];

  String _stakeholderValue = "Brand Owner";
  final List<String> _stakeholderList = [
    "Brand Owner",
    "Manufacturer",
    "Supplier",
    "Distributor",
    "Retailer",
    "Local Authority",
  ];

  @override
  void initState() {
    super.initState();
    _clearSharedPreferences();
  }

  @override
  void dispose() {
    // Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    _adminPasswordController.dispose();

    // Dispose focus nodes
    _emailNode.dispose();
    _passwordNode.dispose();
    _adminPasswordNode.dispose();

    super.dispose();
  }

  // Clear all shared preferences data
  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Admin login method
  Future<void> _adminLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    AppDialogs.loadingDialog(context);

    try {
      final response = await AuthController.loginWithPassword(
        _emailController.text.trim(),
        _adminPasswordController.text.trim(),
      );

      // Save user data to preferences
      await AppPreferences.setToken(response.token.toString());
      await AppPreferences.setGs1UserId(response.user!.gs1Userid.toString());
      await AppPreferences.setUserId(response.user!.id.toString());
      await AppPreferences.setCurrentUser("Admin User");
      await AppPreferences.setGln(response.user!.gln.toString());
      await AppPreferences.setId(response.user!.id.toString());

      AppDialogs.closeDialog();
      AppNavigator.goToPage(context: context, screen: const HomeScreen());
    } catch (error) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(
        context,
        error.toString().replaceAll("Exeption", ""),
      );
    }
  }

  // Brand Owner login method
  Future<void> _brandOwnerLogin() async {
    AppDialogs.loadingDialog(context);

    try {
      final response = await LoginServices.brandOwnerLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Save user data to preferences
      await AppPreferences.setToken(response.token.toString());
      await AppPreferences.setUserId(response.data!.userID.toString());
      await AppPreferences.setNormalUserId(_emailController.text.trim());
      await AppPreferences.setCurrentUser("Brand Owner");

      AppDialogs.closeDialog();
      AppSnackbars.success(context, "Login Successful", 2);
      AppNavigator.replaceTo(context: context, screen: const HomeScreen());
    } catch (error) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(context, error.toString());
    }
  }

  // Supplier login method
  Future<void> _supplierLogin() async {
    AppDialogs.loadingDialog(context);

    try {
      final response = await LoginServices.supplierLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Save user data to preferences
      await AppPreferences.setToken(response.token.toString());
      await AppPreferences.setUserId(response.data!.userId.toString());
      await AppPreferences.setNormalUserId(_emailController.text.trim());
      await AppPreferences.setCurrentUser("Supplier");
      await AppPreferences.setVendorId(response.data!.vendorId.toString());

      AppDialogs.closeDialog();
      AppSnackbars.success(context, "Login Successful", 2);
      AppNavigator.replaceTo(context: context, screen: const HomeScreen());
    } catch (error) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(context, error.toString());
    }
  }

  // Handle login based on selected user type
  Future<void> _handleLogin() async {
    if (_userTypeValue == "Admin User") {
      await _adminLogin();
    } else {
      // Normal user login based on stakeholder type
      if (_stakeholderValue == "Brand Owner") {
        await _brandOwnerLogin();
      } else if (_stakeholderValue == "Supplier") {
        await _supplierLogin();
      } else {
        // Handle other stakeholder types if needed
        AppSnackbars.warning(
            context, "Login for $_stakeholderValue not implemented yet");
      }
    }
  }

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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/trans_logo.png",
                      width: 200,
                      height: 200,
                    ),
                  ),

                  // User Type Dropdown
                  _buildSectionTitle('User Type'),
                  DropDownWidget(
                    items: _userTypeList,
                    value: _userTypeValue,
                    onChanged: (value) {
                      setState(() {
                        _userTypeValue = value!;
                        if (_userTypeValue == "Admin User") {
                          _currentUser = "Admin";
                        }
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Login ID Field
                  _buildSectionTitle('Enter your login ID'),
                  const SizedBox(height: 5),
                  TextFieldWidget(
                    hintText: "Login ID",
                    controller: _emailController,
                    focusNode: _emailNode,
                    keyboardType: TextInputType.emailAddress,
                    leadingIcon: Image.asset(AppIcons.usernameIcon),
                    onFieldSubmitted: (p0) {
                      if (_userTypeValue == "Admin User") {
                        _emailNode.unfocus();
                        FocusScope.of(context).requestFocus(_adminPasswordNode);
                      } else {
                        FocusScope.of(context).requestFocus(_passwordNode);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your login ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Conditional UI based on user type
                  if (_userTypeValue == "Admin User") ...[
                    // Admin Password Field
                    _buildSectionTitle('Enter your password'),
                    const SizedBox(height: 5),
                    TextFieldWidget(
                      hintText: "Password",
                      controller: _adminPasswordController,
                      focusNode: _adminPasswordNode,
                      obscureText: _obscureText,
                      leadingIcon: Image.asset(AppIcons.passwordIcon),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    // Stakeholder Type Dropdown for Normal Users
                    _buildSectionTitle('Stakeholder Type'),
                    DropDownWidget(
                      items: _stakeholderList,
                      value: _stakeholderValue,
                      onChanged: (value) {
                        setState(() {
                          _stakeholderValue = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Field for Normal Users
                    _buildSectionTitle('Enter your password'),
                    const SizedBox(height: 5),
                    TextFieldWidget(
                      hintText: "Password",
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      obscureText: _obscureText,
                      leadingIcon: Image.asset(AppIcons.passwordIcon),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 10),

                  // Remember Me Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        checkColor: AppColors.white,
                        fillColor: WidgetStateProperty.all(AppColors.pink),
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  PrimaryButtonWidget(
                    text: "Login",
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
  }
}

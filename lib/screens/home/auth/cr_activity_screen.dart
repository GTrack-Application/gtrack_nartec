// // ignore_for_file: use_build_context_synchronously, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gtrack_nartec/constants/app_icons.dart';
// import 'package:gtrack_nartec/constants/app_preferences.dart';
// import 'package:gtrack_nartec/cubit/auth/auth_cubit.dart';
// import 'package:gtrack_nartec/cubit/auth/auth_state.dart';
// import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
// import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
// import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
// import 'package:gtrack_nartec/global/widgets/drop_down/drop_down_widget.dart';
// import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
// import 'package:gtrack_nartec/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CrActivityScreen extends StatefulWidget {
//   CrActivityScreen({
//     super.key,
//     required this.dropdownList,
//     required this.dropdownValue,
//     required this.email,
//   });

//   final List<String> dropdownList;
//   String dropdownValue;
//   final String email;

//   @override
//   State<CrActivityScreen> createState() => _CrActivityScreenState();
// }

// class _CrActivityScreenState extends State<CrActivityScreen> {
//   final TextEditingController passwordController = TextEditingController();
//   final FocusNode passwordNode = FocusNode();
//   LoginCubit loginCubit = LoginCubit();
//   final formKey = GlobalKey<FormState>();
//   bool obscureText = true;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     passwordController.dispose();
//     formKey.currentState?.dispose();

//     passwordNode.dispose();

//     super.dispose();
//   }

//   // a method that deletes all the data from the sharedpreferences
//   void clearData() async {
//     await SharedPreferences.getInstance().then((prefs) {
//       prefs.clear();
//     });
//   }

//   bool rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/login_background.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Form(
//           key: formKey,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     child: Image.asset(
//                       "assets/images/trans_logo.png",
//                       width: 200,
//                       height: 200,
//                     ),
//                   ),
//                   const Text(
//                     'CR Activity',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.white,
//                     ),
//                   ),
//                   DropDownWidget(
//                     items: widget.dropdownList,
//                     value: widget.dropdownValue,
//                     onChanged: (value) {
//                       setState(() {
//                         widget.dropdownValue = value!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Password',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.white,
//                     ),
//                   ),
//                   Visibility(
//                     visible:
//                         widget.dropdownValue == "Admin User" ? false : true,
//                     child: TextFieldWidget(
//                       hintText: "Password",
//                       focusNode: passwordNode,
//                       onFieldSubmitted: (p0) {
//                         // hide keyboard
//                         passwordNode.unfocus();
//                       },
//                       controller: passwordController,
//                       leadingIcon: Image.asset(
//                         AppIcons.passwordIcon,
//                         width: 42,
//                         height: 42,
//                       ),
//                       keyboardType: TextInputType.visiblePassword,
//                       obscureText: obscureText,
//                       validator: (p0) {
//                         if (p0!.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.remove_red_eye),
//                         onPressed: () {
//                           setState(() {
//                             obscureText = !obscureText;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   BlocConsumer<LoginCubit, LoginState>(
//                     bloc: loginCubit,
//                     listener: (context, state) async {
//                       if (state is LoginSuccess) {
//                         clearData();
//                         await AppPreferences.setToken(
//                             state.loginResponseModel.token.toString());

//                         await AppPreferences.setUserId(
//                             state.loginResponseModel.memberData!.id.toString());

//                         await AppPreferences.setGcpType(state
//                             .loginResponseModel.memberData!.gcpType
//                             .toString());

//                         await AppPreferences.setGln(state
//                             .loginResponseModel.memberData!.gln
//                             .toString());

//                         await AppPreferences.setGcpGlnId(state
//                             .loginResponseModel.memberData!.gcpGLNID
//                             .toString());

//                         await AppPreferences.setMemberId(state
//                             .loginResponseModel.memberData!.memberID
//                             .toString());

//                         await AppPreferences.setCurrentUser("Member User");

//                         AppNavigator.replaceTo(
//                           context: context,
//                           screen: const HomeScreen(),
//                         );
//                       }
//                       if (state is LoginFailure) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                                 Text(state.error.replaceAll("Exception:", "")),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       return state is LoginLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                   color: AppColors.white),
//                             )
//                           : PrimaryButtonWidget(
//                               backgroungColor: const Color(0xFF4200FF),
//                               onPressed: () {
//                                 // hide the keyboard
//                                 FocusScope.of(context).unfocus();

//                                 if (passwordController.text == "" ||
//                                     passwordController.text.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content:
//                                           Text("Please enter your password"),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 }
//                                 loginCubit.login(
//                                   widget.email.trim(),
//                                   passwordController.text.trim(),
//                                   widget.dropdownValue,
//                                 );
//                               },
//                               text: "Login Now",
//                             );
//                     },
//                   ),
//                   // .box.width(context.width * 0.85).makeCentered(),
//                   const SizedBox(height: 20),
//                   Container(
//                     margin: const EdgeInsets.only(right: 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: rememberMe,
//                               fillColor:
//                                   MaterialStateProperty.all(Colors.white),
//                               activeColor: Colors.white,
//                               checkColor: Colors.black,
//                               onChanged: (value) {
//                                 setState(() {
//                                   rememberMe = value!;
//                                 });
//                               },
//                             ),
//                             const Text(
//                               'Remember Me',
//                               style: TextStyle(
//                                 color: AppColors.grey,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: () {},
//                           child: const Text(
//                             'Need Help?',
//                             style: TextStyle(
//                               color: AppColors.grey,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

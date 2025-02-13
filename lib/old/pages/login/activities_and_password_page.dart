// // ignore_for_file: avoid_print

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gtrack_nartec/constants/app_icons.dart';
// import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
// import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
// import 'package:gtrack_nartec/global/common/utils/custom_dialog.dart';
// import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
// import 'package:gtrack_nartec/global/widgets/drop_down/drop_down_widget.dart';
// import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
// import 'package:gtrack_nartec/models/activities/email_activities_model.dart';
// import 'package:gtrack_nartec/old/domain/services/apis/login/login_services.dart';
// import 'package:gtrack_nartec/old/pages/login/otp_page.dart';

// class ActivitiesAndPasswordPage extends StatefulWidget {
//   final String email;
//   final List<EmailActivitiesModel>? activities;
//   const ActivitiesAndPasswordPage(
//       {super.key, required this.email, this.activities});
//   static const String pageName = '/activitiesAndPassword';

//   @override
//   State<ActivitiesAndPasswordPage> createState() =>
//       _ActivitiesAndPasswordPageState();
// }

// class _ActivitiesAndPasswordPageState extends State<ActivitiesAndPasswordPage> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController passwordController = TextEditingController();
//   final FocusNode passwordFocusNode = FocusNode();
//   bool obscureText = true;
//   List<String> activities = [];
//   String? activityValue;
//   String? activityId;

//   @override
//   void initState() {
//     super.initState();
//     widget.activities?.forEach((element) {
//       if (element.activity != "null" || element.activity != null) {
//         activities.add(element.activity!);
//       }
//     });
//     activityValue = activities[0];
//     activityId = widget.activities!
//         .firstWhere((element) => element.activity == activityValue)
//         .activityID;
//   }

//   showOtpPopup(
//     String message, {
//     String? email,
//     String? activity,
//     String? password,
//     String? generatedOtp,
//   }) {
//     CustomDialog.success(
//       context,
//       title: "OTP",
//       desc: message,
//       btnOkOnPress: () {
//         AppNavigator.goToPage(
//           context: context,
//           screen: OtpPage(
//             email: email.toString(),
//             activity: activity.toString(),
//             activityId: activityId.toString(),
//             password: password.toString(),
//             generatedOtp: generatedOtp.toString(),
//           ),
//         );
//       },
//     );
//   }

//   login() {
//     if (formKey.currentState?.validate() ?? false) {
//       formKey.currentState?.save();
//       if (activityValue != null && passwordController.text.isNotEmpty) {
//         AppDialogs.loadingDialog(context);

//         LoginServices.loginWithPassword(
//           widget.email,
//           activityValue!,
//           passwordController.text.trim(),
//           activityId.toString(),
//         ).then((value) {
//           AppDialogs.closeDialog();
//           final message = value['message'] as String;
//           final generatedOtp = value['otp'] as String;

//           showOtpPopup(
//             message,
//             email: widget.email,
//             activity: activityValue,
//             password: passwordController.text,
//             generatedOtp: generatedOtp,
//           );
//         }).onError((error, stackTrace) {
//           AppDialogs.closeDialog();
//           if (error.toString() == 'Exception: Please Wait For Admin Approval') {
//             AwesomeDialog(
//               context: context,
//               dialogType: DialogType.warning,
//               animType: AnimType.rightSlide,
//               title: 'Message',
//               desc: error.toString().replaceFirst('Exception:', ""),
//               btnOkOnPress: () {},
//             ).show();
//           }
//         });
//       } else {
//         CustomDialog.error(context);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     passwordController.dispose();
//     formKey.currentState?.dispose();

//     // focusnode
//     passwordFocusNode.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: context.width,
//         height: context.height,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/login_background.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   child: Image.asset(
//                     "assets/images/trans_logo.png",
//                     width: 200,
//                     height: 200,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Container(
//                       //   margin: const EdgeInsets.only(left: 60),
//                       //   child: const Text('Select your activity'),
//                       // ),
//                       const Text(
//                         "Select Activity",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       DropDownWidget(
//                         items: activities,
//                         value: activityValue ?? activities[0],
//                         onChanged: (activity) {
//                           setState(() {
//                             activityValue = activity.toString();
//                             activityId = widget.activities!
//                                 .firstWhere((element) =>
//                                     element.activity == activityValue)
//                                 .activityID;
//                           });
//                           print("activityId: $activityId");
//                         },
//                       ),

//                       const SizedBox(height: 30),

//                       const Text(
//                         "Enter Password",
//                         style: TextStyle(
//                           fontSize: 23,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextFieldWidget(
//                         focusNode: passwordFocusNode,
//                         hintText: "Password",
//                         controller: passwordController,
//                         leadingIcon: Image.asset(
//                           AppIcons.passwordIcon,
//                           width: 42,
//                           height: 42,
//                         ),
//                         onFieldSubmitted: (p0) {
//                           FocusScope.of(context).unfocus();
//                           login();
//                         },
//                         keyboardType: TextInputType.visiblePassword,
//                         obscureText: obscureText,
//                         validator: (p0) {
//                           if (p0!.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           return null;
//                         },
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.remove_red_eye),
//                           onPressed: () {
//                             setState(() {
//                               obscureText = !obscureText;
//                             });
//                           },
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         alignment: Alignment.centerRight,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Text(
//                               'Forgot password?',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               child: const Text(
//                                 'Click here',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//                 PrimaryButtonWidget(
//                   onPressed: login,
//                   text: "Login Now",
//                 ),
//                 // .box.width(context.width * 0.85).makeCentered(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

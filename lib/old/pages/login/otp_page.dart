// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gtrack_nartec/constants/app_icons.dart';
// import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
// import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
// import 'package:gtrack_nartec/global/common/utils/app_toast.dart';
// import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
// import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
// import 'package:gtrack_nartec/old/domain/services/apis/login/login_services.dart';
// import 'package:gtrack_nartec/screens/home_screen.dart';

// class OtpPage extends StatefulWidget {
//   final String email, activity, password, generatedOtp, activityId;
//   const OtpPage({
//     super.key,
//     required this.email,
//     required this.activity,
//     required this.password,
//     required this.generatedOtp,
//     required this.activityId,
//   });
//   static const String pageName = '/otp';

//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   final formKey = GlobalKey<FormState>();
//   final otpController = TextEditingController();
//   final FocusNode otpFocusNode = FocusNode();

//   @override
//   void initState() {
//     formKey.currentState?.save();
//     Future.delayed(const Duration(microseconds: 500), () async {
//       try {
//         otpController.text = widget.generatedOtp;
//       } catch (e) {
//         AppToast.danger(context, e.toString());
//       }
//     });
//     super.initState();
//   }

//   verifyOtp() async {
//     if (formKey.currentState!.validate()) {
//       formKey.currentState?.save();

//       try {
//         AppDialogs.loadingDialog(context);
//         await LoginServices.confirmation(
//           context,
//           widget.email.toString(),
//           widget.activity.toString(),
//           widget.activityId,
//           widget.password.toString(),
//           widget.generatedOtp.toString(),
//           otpController.text,
//         );
//         AppDialogs.closeDialog();

//         // Get.toNamed(MenuPage.pageName);
//         AppNavigator.replaceTo(context: context, screen: const HomeScreen());
//       } catch (e) {
//         AppDialogs.closeDialog();
//         AppToast.danger(context, e.toString());
//       }
//     }
//   }

//   @override
//   void dispose() {
//     formKey.currentState?.dispose();
//     otpController.dispose();
//     otpFocusNode.dispose();
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
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Container(
//                     alignment: Alignment.center,
//                     child: Image.asset(
//                       "assets/images/trans_logo.png",
//                       width: 200,
//                       height: 200,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Enter the OTP sent to you!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   TextFieldWidget(
//                     controller: otpController,
//                     leadingIcon: Image.asset(AppIcons.work),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "The field is required";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   PrimaryButtonWidget(text: "Verify OTP", onPressed: verifyOtp),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

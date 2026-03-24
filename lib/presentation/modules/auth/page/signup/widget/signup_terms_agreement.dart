// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wealthnxai/core/themes/app_color.dart';
// import 'package:wealthnxai/presentation/modules/auth/page/signup/controller/signup_page_controller.dart';

// /// Signup Terms Agreement Widget
// /// Reusable terms and conditions checkbox for signup screen
// class SignupTermsAgreement extends StatelessWidget {
//   const SignupTermsAgreement({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final SignupController controller = Get.find<SignupController>();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Obx(
//           () => SizedBox(
//             width: 20,
//             height: 20,
//             child: Checkbox(
//               value: controller.isAgreed.value,
//               onChanged: controller.toggleTermsAgreement,
//             ),
//           ),
//         ),
//         const Text('  Agree with ', style: TextStyle(color: Colors.white)),
//         GestureDetector(
//           onTap: () {
//             // TODO: Navigate to Terms and Conditions page
//             // Get.toNamed(Routes.TERMS_AND_CONDITIONS);
//           },
//           child: const Text(
//             'Terms & Conditions',
//             style: TextStyle(color: Color.fromRGBO(46, 173, 165, 1)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../../../utils/constants/sizes.dart';
// import '../../../../../../utils/constants/text_strings.dart';
// import '../../../../utils/validation/validator.dart';
//
// class LoginFormWidget extends StatelessWidget {
//   const LoginFormWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LoginController());
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: FSizzes.xl),
//       child: Form(
//         key: controller.loginFormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// -- Email Field
//             TextFormField(
//               validator: (value) => FValidator.validateEmail(value),
//               controller: controller.email,
//               decoration: InputDecoration(prefixIcon: Icon(LineAwesomeIcons.user), labelText: FTexts.email, hintText: FTexts.email),
//             ),
//             const SizedBox(height: FSizzes.xl - 20),
//
//             /// -- Password Field
//             Obx(
//                   () => TextFormField(
//                 obscureText: controller.hidePassword.value,
//                 controller: controller.password,
//                 validator: (value) => FValidator.validateEmptyText('Password', value),
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.fingerprint),
//                   labelText: FTexts.password,
//                   hintText: FTexts.password,
//                   suffixIcon: IconButton(
//                     onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
//                     icon: const Icon(Iconsax.eye_slash),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: FSizzes.xl - 20),
//
//             /// -- FORGET PASSWORD BTN
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(onPressed: () => ForgetPasswordScreen.buildShowModalBottomSheet(context), child: const Text(FTexts.forgotPassword)),
//             ),
//
//             /// -- LOGIN BTN
//             Obx(
//                   () => FPrimaryButton(
//                 isLoading: controller.isLoading.value ? true : false,
//                 text: FTexts.login.tr,
//                 onPressed:
//                 controller.isFacebookLoading.value || controller.isGoogleLoading.value
//                     ? () {}
//                     : controller.isLoading.value
//                     ? () {}
//                     : () => controller.emailAndPasswordLogin(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
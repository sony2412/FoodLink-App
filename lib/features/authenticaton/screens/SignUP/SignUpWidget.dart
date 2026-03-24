import 'package:flutter/material.dart';
import 'package:foodlink/features/authenticaton/screens/SignUP/primaryButton.dart';
import 'package:foodlink/features/authenticaton/screens/SignUP/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../utils/validation/validator.dart';


class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FSizzes.spaceBtwSections),
      child: Form(
        key: controller.signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Full Name
            TextFormField(
              controller: controller.fullName,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) => FValidator.validateFullName(value),
              decoration: const InputDecoration(
                labelText: FTexts.fullName,
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Email
            TextFormField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => FValidator.validateEmail(value),
              decoration: const InputDecoration(
                labelText: FTexts.email,
                prefixIcon: Icon(Iconsax.sms),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Phone Number
            TextFormField(
              controller: controller.phoneNumber,
              keyboardType: TextInputType.phone,
              validator: (value) => FValidator.validatePhoneNumber(value),
              decoration: const InputDecoration(
                labelText: FTexts.phoneNumber,
                prefixIcon: Icon(Iconsax.call),
                prefix: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    '+91 ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Password
            Obx(
                  () => TextFormField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                validator: (value) => FValidator.validatePassword(value),
                decoration: InputDecoration(
                  labelText: FTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                    !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Confirm Password
            /// FValidator.validateConfirmPassword(password, confirmPassword)
            Obx(
                  () => TextFormField(
                controller: controller.confirmPassword,
                obscureText: controller.hideConfirmPassword.value,
                validator: (value) => FValidator.validateConfirmPassword(
                  controller.password.text,
                  value,
                ),
                decoration: InputDecoration(
                  labelText: FTexts.confirmPassword,
                  prefixIcon: const Icon(Iconsax.shield_tick),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hideConfirmPassword.value =
                    !controller.hideConfirmPassword.value,
                    icon: Icon(
                      controller.hideConfirmPassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwSections),

            /// Sign Up Button
            Obx(
                  () => FPrimaryButton(
                text: FTexts.signUp,
                isLoading: controller.isLoading.value,
                onPressed: controller.isFacebookLoading.value ||
                    controller.isGoogleLoading.value ||
                    controller.isLoading.value
                    ? () {}
                    : () => controller.signup(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_text_field.dart';
import 'package:foodlink/features/authenticaton/screens/SignUP/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
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
            FTextField(
              controller: controller.fullName,
              keyboardType: TextInputType.name,
              label: FTexts.fullName,
              prefixIcon: Iconsax.user,
              validator: (value) => FValidator.validateFullName(value),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Email
            FTextField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              label: FTexts.email,
              prefixIcon: Iconsax.sms,
              validator: (value) => FValidator.validateEmail(value),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Phone Number
            FTextField(
              controller: controller.phoneNumber,
              keyboardType: TextInputType.phone,
              label: FTexts.phoneNumber,
              prefixIcon: Iconsax.call,
              validator: (value) => FValidator.validatePhoneNumber(value),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Password
            Obx(
              () => FTextField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                label: FTexts.password,
                prefixIcon: Iconsax.password_check,
                validator: (value) => FValidator.validatePassword(value),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(
                    controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: const Color(0xFF5DCAA5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            /// Confirm Password
            Obx(
              () => FTextField(
                controller: controller.confirmPassword,
                obscureText: controller.hideConfirmPassword.value,
                label: FTexts.confirmPassword,
                prefixIcon: Iconsax.shield_tick,
                validator: (value) => FValidator.validateConfirmPassword(
                  controller.password.text,
                  value,
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.hideConfirmPassword.value =
                      !controller.hideConfirmPassword.value,
                  icon: Icon(
                    controller.hideConfirmPassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: const Color(0xFF5DCAA5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FSizzes.spaceBtwSections),

            /// Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () => controller.signup(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF9F27).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              FTexts.signUp,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodlink/common/SignUp_Login/form_divider.dart';
import 'package:foodlink/common/styles/spacing_style.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:foodlink/common/widgets/f_text_field.dart';
import 'package:foodlink/features/authenticaton/controllers/login_controller.dart';
import 'package:foodlink/utils/constants/text_strings.dart';
import 'package:foodlink/utils/helpers/helper_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/SignUp_Login/social_button.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validation/validator.dart';
import '../forgetAndResetPasssword/forgetpassword.dart';
import '../role_selection/role_selection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final String role = Get.arguments ?? 'recipient';
    final dark = FHelperFunctions.isDarkMode(context);

    return FScreenBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: FSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Logo
              Center(
                child: Image(
                  height: 150,
                  image: AssetImage(
                    dark ? FImages.darkAppLogo : FImages.lightAppLogo,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              /// Title & Subtitle
              Text(
                FTexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF9FE1CB),
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: FSizzes.sm),
              Text(
                FTexts.loginSubTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF5DCAA5),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: FSizzes.spaceBtwSections),

              /// Form
              Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    /// Email
                    FTextField(
                      controller: controller.email,
                      label: FTexts.email,
                      prefixIcon: Iconsax.direct_right,
                      validator: (value) => FValidator.validateEmail(value),
                    ),
                    const SizedBox(height: FSizzes.spaceBtwInputFields),

                    /// Password
                    Obx(
                      () => FTextField(
                        controller: controller.password,
                        obscureText: controller.hidePassword.value,
                        label: FTexts.password,
                        prefixIcon: Iconsax.password_check,
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
                        validator: (value) =>
                            FValidator.validateEmptyText('Password', value),
                      ),
                    ),
                    const SizedBox(height: FSizzes.spaceBtwInputFields / 2),

                    /// Remember me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) => controller.rememberMe.value =
                                    !controller.rememberMe.value,
                                activeColor: const Color(0xFF1D9E75),
                                checkColor: Colors.white,
                                side: BorderSide(
                                  color: const Color(0xFF1D9E75)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            const Text(
                              FTexts.rememberMe,
                              style: TextStyle(color: Color(0xFF5DCAA5)),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.to(() => const ForgetpasswordScreen()),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFEF9F27),
                          ),
                          child: const Text(FTexts.forgotPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: FSizzes.spaceBtwSections),

                    /// Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : () => controller.login(role),
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
                                  color: const Color(0xFFEF9F27)
                                      .withValues(alpha: 0.35),
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
                                      FTexts.signIn,
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
                    const SizedBox(height: FSizzes.spaceBtwItems),

                    /// Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Get.to(() => const RoleSelectionScreen()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF5DCAA5),
                          side: BorderSide(
                            color: const Color(0xFF1D9E75).withValues(alpha: 0.6),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          FTexts.createAnAccount,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FSizzes.spaceBtwSections),

              /// Divider
              FormDivider(dividerText: FTexts.orSignInWith.capitalize!),
              const SizedBox(height: FSizzes.spaceBtwSections),

              /// Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(
                    icon: FontAwesomeIcons.google,
                    color: const Color(0xFFDB4437),
                    onTap: () {},
                  ),
                  const SizedBox(width: FSizzes.spaceBtwItems),
                  SocialIconButton(
                    icon: FontAwesomeIcons.facebook,
                    color: const Color(0xFF1877F2),
                    onTap: () {},
                  ),
                  const SizedBox(width: FSizzes.spaceBtwItems),
                  SocialIconButton(
                    icon: FontAwesomeIcons.apple,
                    color: const Color(0xFF9FE1CB),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: FSizzes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

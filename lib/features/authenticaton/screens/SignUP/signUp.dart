import 'package:flutter/material.dart';
import 'package:foodlink/common/SignUp_Login/form_divider.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:foodlink/features/authenticaton/screens/login/login.dart';
import 'package:foodlink/features/authenticaton/screens/signup/SignUpWidget.dart';
import 'package:foodlink/utils/constants/image_strings.dart';
import 'package:foodlink/utils/constants/sizes.dart';
import 'package:foodlink/utils/constants/text_strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.role});

  final String role;

  String get roleLabel {
    switch (role) {
      case 'donor':
        return FTexts.roleDonor;
      case 'recipient':
        return FTexts.roleRecipient;
      case 'volunteer':
        return FTexts.roleVolunteer;
      default:
        return FTexts.register;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScreenBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(FSizzes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header — logo + title + subtitle + role badge
                _SignupHeader(roleLabel: roleLabel),

                /// Form - PASSING ROLE HERE
                SignUpFormWidget(role: role),

                /// Already have account footer
                _SignupFooter(
                  text1: '${FTexts.alreadyHaveAccount.split('?').first}? ',
                  text2: FTexts.signIn,
                  onPressed: () => Get.off(
                    () => const LoginScreen(),
                  ),
                ),

                const SizedBox(height: FSizzes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupHeader extends StatelessWidget {
  const _SignupHeader({required this.roleLabel});

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Logo
        Center(
          child: Image.asset(
            FImages.darkAppLogo,
            height: FSizzes.s80,
          ),
        ),
        const SizedBox(height: FSizzes.spaceBtwItems),

        /// Title
        const Text(
          FTexts.createAnAccount,
          style: TextStyle(
            color: Color(0xFF9FE1CB),
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: FSizzes.sm),

        /// Subtitle
        const Text(
          FTexts.yourAccountCreatedSubTitle,
          style: TextStyle(
            color: Color(0xFF5DCAA5),
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: FSizzes.spaceBtwItems),

        /// Role badge
        Row(
          children: [
            const Text(
              'Signing up as  ',
              style: TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                border: Border.all(
                    color: const Color(0xFFEF9F27).withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                roleLabel,
                style: const TextStyle(
                  color: Color(0xFFFAC775),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignupFooter extends StatelessWidget {
  const _SignupFooter({
    required this.text1,
    required this.text2,
    required this.onPressed,
  });

  final String text1;
  final String text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Already have account
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
            ),
            GestureDetector(
              onTap: onPressed,
              child: Text(
                text2,
                style: const TextStyle(
                  color: Color(0xFFEF9F27),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

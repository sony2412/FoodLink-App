import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../common/SignUp_Login/form_divider.dart';
import '../../../../../common/SignUp_Login/social_button.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../login/login.dart';
import 'SignUpWidget.dart';
import 'widgets/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.role});

  final String role;

  String get roleLabel {
    switch (role) {
      case 'donor':     return FTexts.roleDonor;
      case 'recipient': return FTexts.roleRecipient;
      case 'volunteer': return FTexts.roleVolunteer;
      default:          return FTexts.register;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: SingleChildScrollView(
        child: Stack(
          children: [
        
            /// Ambient blob — top left
            Positioned(
              top: -80, left: -80,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF0F6E56).withValues(alpha: 0.35),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
        
            /// Ambient blob — bottom right
            Positioned(
              bottom: 100, right: -60,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFFBA7517).withValues(alpha: 0.30),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
        
            /// Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(FSizzes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
        
                      /// Header — logo + title + subtitle + role badge
                      _SignupHeader(roleLabel: roleLabel),
        
                      /// Form
                      const SignUpFormWidget(),
        
                      /// Divider
                      FormDivider(
                        dividerText: FTexts.orSignInWith.capitalize!,
                      ),
                      const SizedBox(height: FSizzes.spaceBtwSections),
        
                      /// Social footer
                      _SignupSocialFooter(
                        text1: FTexts.alreadyHaveAccount
                            .split('?')
                            .first + '? ',
                        text2: FTexts.signIn,
                        onPressed: () => Get.off(() => const LoginScreen()),
                      ),
        
                      const SizedBox(height: FSizzes.spaceBtwSections),
                    ],
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

// ── Header widget ─────────────────────────────────────────────────────────────

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
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                border: Border.all(
                    color:
                    const Color(0xFFEF9F27).withValues(alpha: 0.5)),
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

// ── Social footer ─────────────────────────────────────────────────────────────

class _SignupSocialFooter extends StatelessWidget {
  const _SignupSocialFooter({
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

        /// Social buttons row
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

        /// Already have account
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: const TextStyle(
                  color: Color(0xFF5DCAA5), fontSize: 13),
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
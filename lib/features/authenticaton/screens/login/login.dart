import 'package:flutter/material.dart';
import 'package:foodlink/common/SignUp_Login/form_divider.dart';
import 'package:foodlink/common/styles/spacing_style.dart';
import 'package:foodlink/utils/constants/colors.dart';
import 'package:foodlink/utils/constants/text_strings.dart';
import 'package:foodlink/utils/helpers/helper_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/SignUp_Login/social_button.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../role_selection/role_selection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          /// Ambient blobs (same as onboarding)
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0F6E56).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFBA7517).withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Main content
          SingleChildScrollView(
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
                    child: Column(
                      children: [

                        /// Email
                        TextFormField(
                          style: const TextStyle(color: Color(0xFFE8FBF4)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Iconsax.direct_right,
                              color: Color(0xFF5DCAA5),
                            ),
                            labelText: FTexts.email,
                            labelStyle: const TextStyle(color: Color(0xFF5DCAA5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF5DCAA5),
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                          ),
                        ),
                        const SizedBox(height: FSizzes.spaceBtwInputFields),

                        /// Password
                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(color: Color(0xFFE8FBF4)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Iconsax.password_check,
                              color: Color(0xFF5DCAA5),
                            ),
                            suffixIcon: const Icon(
                              Iconsax.eye_slash,
                              color: Color(0xFF5DCAA5),
                            ),
                            labelText: FTexts.password,
                            labelStyle: const TextStyle(color: Color(0xFF5DCAA5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF5DCAA5),
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                          ),
                        ),
                        const SizedBox(height: FSizzes.spaceBtwInputFields / 2),

                        /// Remember me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  activeColor: const Color(0xFF1D9E75),
                                  checkColor: Colors.white,
                                  side: BorderSide(
                                    color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
                                  ),
                                ),
                                const Text(
                                  FTexts.rememberMe,
                                  style: TextStyle(color: Color(0xFF5DCAA5)),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFEF9F27),
                              ),
                              child: const Text(FTexts.forgotPassword),
                            ),
                          ],
                        ),
                        const SizedBox(height: FSizzes.spaceBtwSections),

                        /// Sign In Button (amber gradient)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: GestureDetector(
                            onTap: () {},
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
                              child: const Center(
                                child: Text(
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
                        const SizedBox(height: FSizzes.spaceBtwItems),

                        /// Create Account Button (teal outlined)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                              onPressed: () =>
                                  Get.to(() => const RoleSelectionScreen()),
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
        ],
      ),
    );
  }
}


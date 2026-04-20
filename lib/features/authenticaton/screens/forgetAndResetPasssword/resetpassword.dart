import 'package:flutter/material.dart';
import 'package:foodlink/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../login/login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.clear,
              color: Color(0xFF5DCAA5),
            ),
          ),
        ],
      ),

      body: Stack(
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
            bottom: 80, right: -60,
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(FSizzes.defaultSpace),
              child: Column(
                children: [
                  const SizedBox(height: FSizzes.spaceBtwSections),

                  /// Illustration
                  Image(
                    image: AssetImage(FImages.Delivered),
                    width: FHelperFunctions.screenWidth() * 0.72,
                  ),
                  const SizedBox(height: FSizzes.spaceBtwSections),

                  /// Email sent badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.sms,
                          color: Color(0xFF5DCAA5),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          FTexts.passwordResetSent,
                          style: const TextStyle(
                            color: Color(0xFF5DCAA5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FSizzes.spaceBtwSections),

                  /// Title
                  Text(
                    FTexts.forgotPasswordTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF9FE1CB),
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FSizzes.spaceBtwItems),

                  /// Subtitle
                  Text(
                    FTexts.forgotPasswordSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5DCAA5),
                      height: 1.65,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FSizzes.spaceBtwSections),

                  /// Done button — amber gradient
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: GestureDetector(
                      onTap: () => Get.offAll(() => const LoginScreen()),
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
                        child: const Center(
                          child: Text(
                            FTexts.done,
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

                  /// Resend email — teal outlined button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () => Get.snackbar('Email Sent', 'A new link has been sent to your email',
                            backgroundColor: const Color(0xFF1D9E75), colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5DCAA5),
                        backgroundColor:
                        const Color(0xFF0F6E56).withValues(alpha: 0.15),
                        side: BorderSide(
                          color:
                          const Color(0xFF1D9E75).withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        FTexts.resendEmail,
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
          ),
        ],
      ),
    );
  }
}
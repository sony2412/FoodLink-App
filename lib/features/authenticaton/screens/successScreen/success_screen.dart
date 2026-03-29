import 'package:flutter/material.dart';
import 'package:foodlink/features/authenticaton/screens/login/login.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FSizzes.defaultSpace,
                  vertical: FSizzes.spaceBtwSections,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: FSizzes.spaceBtwSections),

                    /// Success illustration
                    Image(
                      image: AssetImage(FImages.Verified),
                      width: FHelperFunctions.screenWidth() * 0.72,
                    ),
                    const SizedBox(height: FSizzes.spaceBtwSections),

                    /// Success checkmark badge
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1D9E75)
                                .withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: FSizzes.spaceBtwSections),

                    /// Title
                    Text(
                      FTexts.yourAccountCreatedTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        color: const Color(0xFF9FE1CB),
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: FSizzes.spaceBtwItems),

                    /// Subtitle
                    Text(
                      FTexts.yourAccountCreatedSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5DCAA5),
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: FSizzes.spaceBtwSections),

                    /// Continue to Login — amber gradient button
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
                              FTexts.Continue,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
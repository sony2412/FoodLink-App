import 'package:flutter/material.dart';
import 'package:foodlink/features/authenticaton/screens/forgetAndResetPasssword/resetpassword.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class ForgetpasswordScreen extends StatelessWidget {
  const ForgetpasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF5DCAA5), size: 20),
        ),
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
          Padding(
            padding: const EdgeInsets.all(FSizzes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Lock icon
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.3),
                    border: Border.all(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Iconsax.lock,
                    color: Color(0xFF5DCAA5),
                    size: 28,
                  ),
                ),
                const SizedBox(height: FSizzes.spaceBtwItems),

                /// Title
                Text(
                  FTexts.forgotPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF9FE1CB),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: FSizzes.spaceBtwItems),

                /// Subtitle
                Text(
                  FTexts.forgotPasswordSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5DCAA5),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: FSizzes.spaceBtwSections),

                /// Email field
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color(0xFFE8FBF4)),
                  decoration: InputDecoration(
                    labelText: FTexts.email,
                    labelStyle: const TextStyle(color: Color(0xFF5DCAA5)),
                    prefixIcon: const Icon(
                      Iconsax.direct_right,
                      color: Color(0xFF5DCAA5),
                    ),
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
                const SizedBox(height: FSizzes.spaceBtwSections),

                /// Submit button — amber gradient
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: GestureDetector(
                    onTap: () => Get.off(() => const ResetPasswordScreen()),
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
                          FTexts.submit,
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
        ],
      ),
    );
  }
}
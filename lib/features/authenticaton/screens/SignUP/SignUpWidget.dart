import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_text_field.dart';
import 'package:foodlink/features/authenticaton/screens/SignUP/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validation/validator.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key, required this.role});

  final String role;

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

            // Dropdown for User Type
            Obx(() => DropdownButtonFormField<String>(
              value: (role == 'donor' ? ['Individual', 'Restaurant', 'Event Organizer', 'Household', 'Other'] : ['NGO', 'Orphanage', 'Old Age Home', 'Individual', 'Other']).contains(controller.userType.value) ? controller.userType.value : 'Individual',
              dropdownColor: const Color(0xFF0F6E56),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.category, color: Color(0xFF5DCAA5), size: 20),
                labelText: role == 'donor' ? 'Donor Type' : 'Recipient Type',
                labelStyle: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
                floatingLabelStyle: const TextStyle(color: Color(0xFF9FE1CB)),
                filled: true,
                fillColor: const Color(0xFF0F6E56).withOpacity(0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.3))),
              ),
              items: (role == 'donor' ? ['Individual', 'Restaurant', 'Event Organizer', 'Household', 'Other'] : ['NGO', 'Orphanage', 'Old Age Home', 'Individual', 'Other'])
                  .map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) {
                if (val != null) controller.userType.value = val;
              },
            )),
            const SizedBox(height: FSizzes.spaceBtwInputFields),

            Obx(() {
              final isIndividual = controller.userType.value == 'Individual' || controller.userType.value == 'Household';
              return isIndividual ? const SizedBox.shrink() : Column(
                children: [
                  FTextField(
                    controller: controller.organizationName,
                    keyboardType: TextInputType.name,
                    label: role == 'donor' ? 'Organization / Business Name' : 'NGO / Shelter Name',
                    prefixIcon: Iconsax.building,
                    validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: FSizzes.spaceBtwInputFields),
                ],
              );
            }),

            // Address field with Geolocation
            FTextField(
              controller: controller.organizationAddress,
              keyboardType: TextInputType.streetAddress,
              label: 'Address / Area',
              prefixIcon: Iconsax.location,
              validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
              suffixIcon: Obx(() => IconButton(
                onPressed: controller.isLocationLoading.value ? null : controller.getCurrentLocation,
                icon: controller.isLocationLoading.value 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF9F27)))
                  : const Icon(Iconsax.gps, color: Color(0xFFEF9F27), size: 20),
              )),
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
                      : () => controller.signup(role),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../SignUP/signUp.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  final List<Map<String, dynamic>> roles = [
    {
      'id': 'donor',
      'title': 'Food Donor',
      'subtitle': 'Restaurants, homes, or stores with surplus food to share.',
      'icon': Iconsax.cake,
      'badge': 'Give food',
    },
    {
      'id': 'recipient',
      'title': 'Food Recipient',
      'subtitle': 'Shelters, NGOs, or individuals who need food support.',
      'icon': Iconsax.heart,
      'badge': 'Receive food',
    },
    {
      'id': 'volunteer',
      'title': 'Volunteer',
      'subtitle': 'Help pick up and deliver food between donors and recipients.',
      'icon': Iconsax.truck,
      'badge': 'Deliver food',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          /// Ambient blobs
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
            bottom: 100,
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                        border: Border.all(
                          color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Iconsax.arrow_left,
                        color: Color(0xFF5DCAA5),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  /// Title
                  const Text(
                    'Join as a...',
                    style: TextStyle(
                      color: Color(0xFF9FE1CB),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose how you want to contribute\nto reducing food waste.',
                    style: TextStyle(
                      color: Color(0xFF5DCAA5),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  /// Role cards
                  Expanded(
                    child: ListView.separated(
                      itemCount: roles.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final role = roles[index];
                        final isSelected = selectedRole == role['id'];
                        return _RoleCard(
                          title: role['title'],
                          subtitle: role['subtitle'],
                          icon: role['icon'],
                          badge: role['badge'],
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              selectedRole = role['id'];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: GestureDetector(
                      onTap: selectedRole == null
                          ? null
                          : () {
                        Get.to(() => SignUpScreen(role: selectedRole!));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: selectedRole != null
                              ? const LinearGradient(
                            colors: [
                              Color(0xFFEF9F27),
                              Color(0xFFBA7517)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: selectedRole == null
                              ? const Color(0xFF0F6E56).withValues(alpha: 0.2)
                              : null,
                          boxShadow: selectedRole != null
                              ? [
                            BoxShadow(
                              color: const Color(0xFFEF9F27)
                                  .withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                          border: selectedRole == null
                              ? Border.all(
                            color: const Color(0xFF1D9E75)
                                .withValues(alpha: 0.25),
                          )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: selectedRole != null
                                  ? Colors.white
                                  : const Color(0xFF5DCAA5)
                                  .withValues(alpha: 0.4),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.isSelected,
    required this.onTap,
  });

  final String title, subtitle, badge;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? const Color(0xFF0F6E56).withValues(alpha: 0.35)
              : const Color(0xFF0F6E56).withValues(alpha: 0.10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5DCAA5)
                : const Color(0xFF1D9E75).withValues(alpha: 0.25),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            /// Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected
                    ? null
                    : const Color(0xFF0F6E56).withValues(alpha: 0.3),
                border: isSelected
                    ? null
                    : Border.all(
                  color:
                  const Color(0xFF1D9E75).withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF5DCAA5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF9FE1CB)
                              : const Color(0xFF5DCAA5),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),

                      /// Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEF9F27).withValues(alpha: 0.20)
                              : const Color(0xFF1D9E75).withValues(alpha: 0.15),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFEF9F27)
                                .withValues(alpha: 0.55)
                                : const Color(0xFF1D9E75)
                                .withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFFAC775)
                                : const Color(0xFF5DCAA5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            /// Selected indicator
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF1D9E75)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5DCAA5)
                      : const Color(0xFF1D9E75).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
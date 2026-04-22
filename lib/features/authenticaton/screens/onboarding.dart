import 'package:flutter/material.dart';
import 'package:foodlink/utils/constants/image_strings.dart';
import 'package:foodlink/utils/constants/text_strings.dart';
import 'package:foodlink/utils/device/device_utility.dart';
import 'package:foodlink/utils/helpers/helper_functions.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/constants/sizes.dart';
import '../controller_onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: FImages.order_food,
                title: FTexts.onboarding1Title,
                subtTitle: FTexts.onboarding1Subtitle,
                badgeLabel: 'Discover food',
              ),
              OnBoardingPage(
                image: FImages.charity,
                title: FTexts.onboarding2Title,
                subtTitle: FTexts.onboarding2Subtitle,
                badgeLabel: 'Share surplus',
              ),
              OnBoardingPage(
                image: FImages.community,
                title: FTexts.onboarding3Title,
                subtTitle: FTexts.onboarding3Subtitle,
                badgeLabel: 'Connect now',
              ),
            ],
          ),
          const _AmbientBlobs(),
          const OnBoardingSkip(),
          const DotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}

class _AmbientBlobs extends StatelessWidget {
  const _AmbientBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                  const Color(0xFF0F6E56).withOpacity(0.35),
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
                  const Color(0xFFBA7517).withOpacity(0.30),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: FSizzes.defaultSpace,
      bottom: FDeviceUtility.getBottomNavigationBarHeight(),
      child: GestureDetector(
        onTap: () => OnBoardingController.instance.nextpage(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF9F27).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Iconsax.arrow_right_3, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class DotNavigation extends StatelessWidget {
  const DotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
      bottom: FDeviceUtility.getBottomNavigationBarHeight() + 25,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: const Color(0xFF5DCAA5),
            dotColor: const Color(0xFF1D9E75).withOpacity(0.3),
            dotHeight: 7,
            dotWidth: 7,
            expansionFactor: 4.0,
          ),
        ),
      ),
    );
  }
}

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: FDeviceUtility.getAppBarHeight() + 8,
      right: FSizzes.defaultSpace,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5DCAA5),
          backgroundColor: const Color(0xFF0F6E56).withOpacity(0.15),
          side: BorderSide(color: const Color(0xFF0F6E56).withOpacity(0.4)),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtTitle,
    required this.badgeLabel,
  });

  final String image, title, subtTitle, badgeLabel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(FSizzes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: FDeviceUtility.getAppBarHeight() - 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F6E56), Color(0xFF1D9E75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFF1D9E75).withOpacity(0.3),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image(
                    width: FHelperFunctions.screenWidth() * 0.85,
                    height: FHelperFunctions.screenHeight() * 0.42,
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.05),
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF9F27).withOpacity(0.20),
                        border: Border.all(
                          color: const Color(0xFFEF9F27).withOpacity(0.55),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          color: Color(0xFFFAC775),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF9FE1CB),
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FSizzes.spaceBtwItems),
            Text(
              subtTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5DCAA5),
                height: 1.65,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100), // Spacing for bottom controls
          ],
        ),
      ),
    );
  }
}
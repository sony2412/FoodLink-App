import 'package:flutter/material.dart';
import 'package:foodlink/utils/theme/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'features/authenticaton/screens/onboarding.dart';

class FoodLink extends StatelessWidget {
  const FoodLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp (
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: FAppTheme.lightTheme,
      darkTheme: FAppTheme.darkTheme,
      home:const OnBoardingScreen(),
    );
  }
}
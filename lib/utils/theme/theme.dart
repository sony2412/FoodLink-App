import 'package:flutter/material.dart';
import 'package:foodlink/utils/theme/custom_themes/appbar_themes.dart';
import 'package:foodlink/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:foodlink/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:foodlink/utils/theme/custom_themes/chip_theme.dart';
import 'package:foodlink/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:foodlink/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:foodlink/utils/theme/custom_themes/text_themes.dart';
import 'package:foodlink/utils/theme/custom_themes/textfield_theme.dart';

class FAppTheme {
  FAppTheme._();  //theme constructor not be used again, making the constructor private

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white, //since scaffold is treated mainly as different background
    textTheme: FAppTextTheme.lightTextTheme,
    chipTheme: FChipTheme.lightChip,
    appBarTheme: FAppbarThemes.lightAppBarTheme,
    checkboxTheme: FCheckboxTheme.lightCheckbox,
    bottomSheetTheme: FBottomSheetTheme.lightBottom,
    outlinedButtonTheme: FOutlinedButtonTheme.lightOutlined,
    inputDecorationTheme: FTextFormField.lightInput,
    elevatedButtonTheme: FAppElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black, //since scaffold is treated mainly as different background
    textTheme: FAppTextTheme.darkTextTheme,
    chipTheme: FChipTheme.darkChip,
    appBarTheme: FAppbarThemes.darkAppBarTheme,
    checkboxTheme: FCheckboxTheme.darkCheckbox,
    bottomSheetTheme: FBottomSheetTheme.darkBottom,
    outlinedButtonTheme: FOutlinedButtonTheme.darkOutlined,
    inputDecorationTheme: FTextFormField.darkInput,
    elevatedButtonTheme: FAppElevatedButtonTheme.darkElevatedButtonTheme,

  );

}
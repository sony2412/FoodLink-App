import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class FSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: FSizzes.appBarHeightMd,
    left: FSizzes.defaultSpace,
    bottom: FSizzes.defaultSpace,
    right: FSizzes.defaultSpace,
  );
  static const EdgeInsetsGeometry paddingWithDefaultWidth = EdgeInsets.only(
    left: FSizzes.defaultSpace,
    right: FSizzes.defaultSpace,
  );

  static const EdgeInsetsGeometry paddingOnlyVertical = EdgeInsets.symmetric(
    vertical: FSizzes.defaultSpace,
  );

  static const EdgeInsetsGeometry paddingWithDefaultHeight = EdgeInsets.only(
    top: FSizzes.defaultSpace,
    left: FSizzes.defaultSpace,
    bottom: FSizzes.defaultSpace,
    right: FSizzes.defaultSpace,
  );
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FHelperFunctions {

  // ── Color Helpers ──────────────────────────────────────────────

  /// Maps dietary/status label to a color for UI badges
  static Color getDietaryColor(String value) {
    switch (value.toLowerCase()) {
      case 'vegetarian':   return Colors.green;
      case 'vegan':        return Colors.lightGreen;
      case 'non-vegetarian':
      case 'non veg':      return Colors.red;
      case 'gluten-free':  return Colors.orange;
      case 'dairy-free':   return Colors.blue;
      default:             return Colors.grey;
    }
  }

  /// Maps listing/claim status to a color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':   return Colors.green;
      case 'claimed':     return Colors.orange;
      case 'expired':     return Colors.red;
      case 'cancelled':   return Colors.grey;
      case 'pending':     return Colors.amber;
      case 'approved':    return Colors.green;
      case 'rejected':    return Colors.red;
      case 'completed':   return Colors.teal;
      default:            return Colors.grey;
    }
  }

  // ── Screen / Layout ────────────────────────────────────────────

  static double getTopSafeArea(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  static double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static Size screenSize() => MediaQuery.of(Get.context!).size;
  static double screenHeight() => MediaQuery.of(Get.context!).size.height;
  static double screenWidth() => MediaQuery.of(Get.context!).size.width;

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  // ── Snackbars & Dialogs ────────────────────────────────────────

  static void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackBar(String message) =>
      showSnackBar(message, backgroundColor: Colors.green);

  static void showErrorSnackBar(String message) =>
      showSnackBar(message, backgroundColor: Colors.redAccent);

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Confirm dialog — used for delete listing, cancel claim, etc.
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Navigation ─────────────────────────────────────────────────

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ── Text Helpers ───────────────────────────────────────────────

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter of each word — for food item names
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  // ── Phone Number ───────────────────────────────────────────────

  static String maskPhoneNumber(String number) {
    if (number.length > 6) {
      final visibleStart = number.substring(0, 2);
      final visibleEnd = number.substring(number.length - 3);
      final maskedPart = '*' * (number.length - visibleStart.length - visibleEnd.length);
      return '$visibleStart $maskedPart $visibleEnd';
    }
    return number;
  }

  // ── Distance ───────────────────────────────────────────────────

  /// Used on listing cards to show distance from user
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      final meters = (distanceInKm * 1000).round();
      return '$meters m away';
    }
    return '${distanceInKm.toStringAsFixed(1)} km away';
  }

  // ── Food / Listing Specific ────────────────────────────────────

  /// Check if a food listing is expiring within [withinHours] hours
  static bool isExpiringSoon(DateTime expiryDate, {int withinHours = 24}) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);
    return difference.inHours <= withinHours && !difference.isNegative;
  }

  /// Check if a listing is already expired
  static bool isExpired(DateTime expiryDate) {
    return DateTime.now().isAfter(expiryDate);
  }

  /// Returns a warning level for expiry — useful for color-coding
  /// 0 = fresh, 1 = expiring soon, 2 = expired
  static int expiryWarningLevel(DateTime expiryDate) {
    if (isExpired(expiryDate)) return 2;
    if (isExpiringSoon(expiryDate)) return 1;
    return 0;
  }

  // ── Date ───────────────────────────────────────────────────────

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static DateTime? convertToDateTime<T>(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value.runtimeType.toString() == 'Timestamp' || (value is T)) {
      try {
        return value.toDate();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // ── List Helpers ───────────────────────────────────────────────

  static List<T> removeDuplicates<T>(List<T> list) => list.toSet().toList();

  // ── Referral ───────────────────────────────────────────────────

  /// Generate donor referral code e.g. "SONY482"
  static String generateReferralCode(String firstName) {
    final random = Random();
    final randomNumber = random.nextInt(1000);
    return firstName.toUpperCase() + randomNumber.toString();
  }
}
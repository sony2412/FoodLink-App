import 'package:intl/intl.dart';

class FFormatter {

  // ── Date & Time ────────────────────────────────────────────────

  static String formatDateAndTime(DateTime? date, {bool use24HourFormat = false}) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    final timeFormat = use24HourFormat ? 'HH:mm' : 'hh:mm a';
    final onlyTime = DateFormat(timeFormat).format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  /// Shows how long ago a listing was posted e.g. "2 hours ago", "3 days ago"
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    if (difference.inDays < 7) return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }
    return formatDate(date);
  }

  /// Format expiry/best-before date for food listings
  static String formatExpiryDate(DateTime? expiryDate) {
    if (expiryDate == null) return 'No expiry date';
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) return 'Expired';
    if (difference.inHours < 1) return 'Expires in less than an hour';
    if (difference.inHours < 24) return 'Expires in ${difference.inHours}h';
    if (difference.inDays == 1) return 'Expires tomorrow';
    if (difference.inDays <= 3) return 'Expires in ${difference.inDays} days ⚠️';
    return 'Best before: ${DateFormat('dd MMM yyyy').format(expiryDate)}';
  }

  /// Format pickup time slot e.g. "Today, 3:00 PM – 5:00 PM"
  static String formatPickupWindow(DateTime start, DateTime end) {
    final now = DateTime.now();
    final isToday = start.day == now.day && start.month == now.month && start.year == now.year;
    final isTomorrow = start.day == now.day + 1 && start.month == now.month;

    final dayLabel = isToday ? 'Today' : isTomorrow ? 'Tomorrow' : DateFormat('dd MMM').format(start);
    final startTime = DateFormat('hh:mm a').format(start);
    final endTime = DateFormat('hh:mm a').format(end);

    return '$dayLabel, $startTime – $endTime';
  }

  // ── Currency ───────────────────────────────────────────────────

  /// Format currency based on locale — defaults to INR for FoodLink's primary market
  static String formatCurrency(double amount, {String locale = 'en_IN', String symbol = '₹'}) {
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }

  /// For donations that are free, show "Free" instead of ₹0.00
  static String formatDonationAmount(double amount) {
    if (amount == 0.0) return 'Free';
    return formatCurrency(amount);
  }

  // ── Quantity ───────────────────────────────────────────────────

  /// Format food quantity with unit e.g. "2.5 kg", "10 plates"
  static String formatQuantity(double quantity, String unit) {
    final formatted = quantity == quantity.floorToDouble()
        ? quantity.toInt().toString()
        : quantity.toString();
    return '$formatted $unit';
  }

  /// Format distance for nearby listings e.g. "0.8 km away", "250 m away"
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      final meters = (distanceInKm * 1000).round();
      return '$meters m away';
    }
    return '${distanceInKm.toStringAsFixed(1)} km away';
  }

  // ── Phone Number ───────────────────────────────────────────────

  /// Format Indian phone number: 98765 43210
  static String formatPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 5)} ${digits.substring(5)}';
    } else if (digits.length == 11) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return phoneNumber;
  }

  static String internationalFormatPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') groupLength = 3;
      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));
      if (end < digitsOnly.length) formattedNumber.write(' ');
      i = end;
    }

    return formattedNumber.toString();
  }

  static String formatPhoneNumberWithCountryCode(String countryCode, String phoneNumber) {
    return '$countryCode$phoneNumber';
  }

  // ── Misc / UI ──────────────────────────────────────────────────

  /// Capitalize first letter of each word e.g. for food item names
  static String formatTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  /// Truncate long food descriptions for cards
  static String formatTruncated(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength).trimRight()}...';
  }

  /// Format impact stats e.g. 1200 → "1.2K meals"
  static String formatImpactCount(int count, String label) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K $label';
    }
    return '$count $label';
  }
}
import 'dart:math';
import 'dart:developer' as d;
import 'package:eexily/components/order.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> launchPayStackUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

void showToast(String message, BuildContext context, {Color? backgroundColor}) {
  HapticFeedback.mediumImpact();
  context.messenger.showSnackBar(
    SnackBar(
      elevation: 1.0,
      backgroundColor: backgroundColor ?? Colors.redAccent,
      content: Text(
        message,
        style: context.textTheme.bodyMedium!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

void unFocus() => FocusManager.instance.primaryFocus?.unfocus();

String formatRawAmount(num price) => formatAmount(price.toString());

String formatAmount(String price) {
  String priceInText = "";
  int counter = 0;
  for (int i = (price.length - 1); i >= 0; i--) {
    counter++;
    String str = price[i];
    if ((counter % 3) != 0 && i != 0) {
      priceInText = "$str$priceInText";
    } else if (i == 0) {
      priceInText = "$str$priceInText";
    } else {
      priceInText = ",$str$priceInText";
    }
  }
  return priceInText.trim();
}

String format(double val) =>
    val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 2);

String formatDate(String dateTime,
    {bool shorten = false, bool withTime = false}) {
  int firIndex = dateTime.indexOf("/");
  String d = dateTime.substring(0, firIndex);
  int secIndex = dateTime.indexOf("/", firIndex + 1);
  String m = dateTime.substring(firIndex + 1, secIndex);
  String y = dateTime.substring(secIndex + 1);

  return "${month(m, shorten)} ${day(d)}, $y";
}

bool isLeapYear(int year) {
  if (year % 4 == 0) {
    if (year % 100 == 0) {
      return year % 400 == 0;
    } else {
      return true;
    }
  } else {
    return false;
  }
}

int getDaysOfMonth(int month, int year) {
  if (month == 4 || month == 6 || month == 9 || month == 11) return 30;
  if (month == 2) {
    return isLeapYear(year) ? 29 : 28;
  }
  return 31;
}

String getWeekDay(int day, {bool shorten = false}) {
  switch (day) {
    case 1:
      return shorten ? "Mon" : "Monday";
    case 2:
      return shorten ? "Tue" : "Tuesday";
    case 3:
      return shorten ? "Wed" : "Wednesday";
    case 4:
      return shorten ? "Thur" : "Thursday";
    case 5:
      return shorten ? "Fri" : "Friday";
    case 6:
      return shorten ? "Sat" : "Saturday";
    case 7:
      return shorten ? "Sun" : "Sunday";
    default:
      return "";
  }
}

String month(String val, bool shorten) {
  int month = int.parse(val);
  switch (month) {
    case 1:
      return shorten ? "Jan" : "January";
    case 2:
      return shorten ? "Feb" : "February";
    case 3:
      return shorten ? "Mar" : "March";
    case 4:
      return shorten ? "Apr" : "April";
    case 5:
      return "May";
    case 6:
      return shorten ? "Jun" : "June";
    case 7:
      return shorten ? "Jul" : "July";
    case 8:
      return shorten ? "Aug" : "August";
    case 9:
      return shorten ? "Sep" : "September";
    case 10:
      return shorten ? "Oct" : "October";
    case 11:
      return shorten ? "Nov" : "November";
    default:
      return shorten ? "Dec" : "December";
  }
}

String day(String val) {
  int day = int.parse(val);
  int remainder = day % 10;
  switch (remainder) {
    case 1:
      return (day == 11) ? "${day}th" : "${day}st";
    case 2:
      return (day == 12) ? "${day}th" : "${day}nd";
    case 3:
      return (day == 13) ? "${day}th" : "${day}rd";
    default:
      return "${day}th";
  }
}

String formatDateRawWithTime(DateTime date, {bool shorten = false}) =>
    "${formatDate(DateFormat("dd/MM/yyy").format(date), shorten: shorten)}: ${convertTime(date)}";

String formatDateRaw(DateTime date, {bool shorten = false}) =>
    formatDate(DateFormat("dd/MM/yyy").format(date), shorten: shorten);

String formatDuration(int total) {
  int hr = total ~/ 3600;
  int min = total ~/ 60;
  int secs = total - ((hr * 3600) - (min * 60));
  return "${hr < 10 ? "0" : ""}$hr:${min < 10 ? "0" : ""}$min:${secs < 10 ? "0" : ""}$secs";
}

String convertTime(DateTime date) {
  bool isPM = date.hour > 11;
  int hours = date.hour;
  int minutes = date.minute;
  return "${hours == 0 ? "" : hours % 12 < 10 ? "0" : ""}${hours == 0 || hours % 12 == 0 ? "12" : hours % 12}:${minutes < 10 ? "0" : ""}$minutes ${isPM ? "PM" : "AM"}";
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  int i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}

bool validateForm(GlobalKey<FormState> formKey) {
  unFocus();
  FormState? currentState = formKey.currentState;
  if (currentState != null) {
    if (!currentState.validate()) return false;

    currentState.save();
    return true;
  }
  return false;
}

List<String> toStringList(List<dynamic> data) {
  List<String> result = [];
  for (var element in data) {
    result.add(element as String);
  }
  return result;
}

Color randomColor(String id) {
  Random random = Random(id.hashCode);

  final red = random.nextInt(256);
  final green = random.nextInt(256);
  final blue = random.nextInt(256);

  return Color.fromARGB(255, red, green, blue);
}

double calculateLuminance(Color color) {
  final r = color.red / 255.0;
  final g = color.green / 255.0;
  final b = color.blue / 255.0;

  const lumR = 0.2126;
  const lumG = 0.7152;
  const lumB = 0.0722;

  return lumR * r + lumG * g + lumB * b;
}

Color gasColor(double value) {
  if (value > 0.55) {
    return secondary2;
  } else if (value >= 0.16 && value <= 0.55) {
    return secondary;
  }
  return Colors.red;
}

Color chooseTextColor(Color backgroundColor) {
  final luminance = calculateLuminance(backgroundColor);
  return luminance > 0.5 ? Colors.black : Colors.white;
}

String get randomGCode {
  Random random = Random(DateTime.now().millisecondsSinceEpoch);
  String randomNumber = random.nextInt(999).toString().padLeft(3, "0");
  String pre = String.fromCharCode(random.nextInt(26) + 65),
      suf = String.fromCharCode(random.nextInt(26) + 65);
  return "$pre$randomNumber$suf";
}

String getRandomIDWithSeed(int seed) {
  Random random = Random(seed);
  String randomNumber = random.nextInt(9999).toString().padLeft(4, "0");
  String pre = String.fromCharCode(random.nextInt(26) + 65),
      suf = String.fromCharCode(random.nextInt(26) + 65);
  return "$pre$randomNumber$suf";
}

String get randomOrderID {
  Random random = Random(DateTime.now().millisecondsSinceEpoch);
  return random.nextInt(999999).toString().padLeft(6, "0");
}

class DateUtilities {
  static DateTime getDaysAgo(int day) {
    return DateTime.now().subtract(Duration(days: day));
  }

  static DateTime getDaysAhead(int day) {
    return DateTime.now().add(Duration(days: day));
  }

  static DateTime getMinutesBefore(int minutes) {
    return DateTime.now().subtract(Duration(minutes: minutes));
  }

  static DateTime getCurrentWeekStart() {
    return DateTime.now().startOfWeek;
  }

  static DateTime getCurrentWeekEnd() {
    return DateTime.now().endOfWeek;
  }

  static DateTime getLastWeekStart() {
    return DateTime.now().subtract(const Duration(days: 7)).startOfWeek;
  }

  static DateTime getLastWeekEnd() {
    return DateTime.now().subtract(const Duration(days: 7)).endOfWeek;
  }

  static DateTime getCurrentMonthStart() {
    return DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  static DateTime getCurrentMonthEnd() {
    return DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  }

  static DateTime getLastMonthStart() {
    return DateTime.now().subtract(const Duration(days: 30)).startOfMonth;
  }

  static DateTime getLastMonthEnd() {
    return DateTime.now().subtract(const Duration(days: 30)).endOfMonth;
  }

  static DateTime getPreviousMonthStart() {
    return DateTime.now().subtract(const Duration(days: 30)).startOfMonth;
  }

  static DateTime getPreviousMonthEnd() {
    return DateTime.now().subtract(const Duration(days: 30)).endOfMonth;
  }

  static DateTime getYearsAhead(int years) {
    return DateTime.now().add(Duration(days: 365 * years));
  }

  static DateTime getThreeMonthsAgoStart() {
    return DateTime.now().subtract(const Duration(days: 90));
  }

  static DateTime getThreeMonthsAgoEnd() {
    return DateTime.now().subtract(const Duration(days: 90)).endOfMonth;
  }
}

// Helper methods
extension DateTimeExtensions on DateTime {
  DateTime get startOfWeek =>
      DateTime(year, this.month, this.day - weekday + 1);

  DateTime get endOfWeek =>
      DateTime(year, this.month, this.day + (7 - weekday));

  DateTime get startOfMonth => DateTime(year, this.month, 1);

  DateTime get endOfMonth => DateTime(year, this.month + 1, 0);

  String get shortDayName => getWeekDay(this.day, shorten: true);

  String get longDayName => getWeekDay(this.day, shorten: false);

  String get shortMonthName => month("${this.month}", true);

  String get longMonthName => month("${this.month}", false);
}

String getUniqueImageUrl(String value) =>
    "https://gravatar.com/avatar/${value.hashCode}?s=400&d=robohash&r=x";

Future<void> launchPhoneNumber(String phone) async {
  Uri uri = Uri.parse("tel:+234${phone.substring(1)}");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

class FilterOption {
  final List<Order> orders;
  final int filterIndex;

  const FilterOption({
    required this.orders,
    required this.filterIndex,
  });
}

Future<List<Order>> filterDriverOrders(FilterOption option) async {
  List<Order> response = [];
  for (Order order in option.orders) {
    if ((option.filterIndex == 1 && order.status == "PAID") ||
        (option.filterIndex == 2 && order.status == "REFILLED") ||
        (option.filterIndex == 3 && order.status == "DELIVERED")) {
      response.add(order);
    }
  }

  return response;
}

Future<List<Order>> filterOtherOrders(FilterOption option) async {
  List<Order> response = [];
  for (Order order in option.orders) {
    if ((option.filterIndex == 1 && order.status == "PAID") ||
        (option.filterIndex == 2 && order.status == "REFILLED")) {
      response.add(order);
    }
  }

  return response;
}

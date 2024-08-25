import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

void showToast(String message, BuildContext context, {Color? backgroundColor}) {
  HapticFeedback.vibrate();
  AnimatedSnackBar snackBar = AnimatedSnackBar(
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 10.w,
        maxWidth: 220.w,
        minHeight: 40.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? primary,
          borderRadius: BorderRadius.circular(5.r),
        ),
        alignment: Alignment.center,
        child: Text(
          message,
          style: context.textTheme.bodySmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    animationCurve: Curves.ease,
    snackBarStrategy: RemoveSnackBarStrategy(),
    duration: const Duration(seconds: 4),
    animationDuration: const Duration(milliseconds: 350),
  );
  snackBar.show(context);
}

void unFocus() => FocusManager.instance.primaryFocus?.unfocus();

String formatRawAmount(int price) => formatAmount(price.toString());

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

String formatDate(String dateTime, {bool shorten = false}) {
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

String formatDateRaw(DateTime date, {bool shorten = false}) =>
    formatDate(DateFormat("dd/MM/yyy").format(date), shorten: shorten);

String formatDateWithTime(DateTime date, {bool shorten = false}) =>
    formatDate(DateFormat("dd/MM/yyy").format(date), shorten: shorten);

String formatDuration(int total) {
  int hr = total ~/ 3600;
  int min = total ~/ 60;
  int secs = total - ((hr * 3600) - (min * 60));
  return "${hr < 10 ? "0" : ""}$hr:${min < 10 ? "0" : ""}$min:${secs < 10 ? "0" : ""}$secs";
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color primary = Color(0xFF0054C2);
const Color primary50 = Color(0xFFB1D3FF);
const Color secondary = Color(0xFFFFBE03);
const Color secondary2 = Color(0xFF42CD00);
const Color secondary3 = Color(0xFF00DBB3);
const Color secondary4 = Color(0xFF21EF00);
const Color monokai = Color(0xFF0A0A0A);
const Color neutral = Color.fromARGB(35, 152, 152, 152);
const Color neutral2 = Color(0xFF494949);
Color neutral3 = const Color(0xFF494949).withOpacity(0.5);
const Color bellySaver = Color(0xFF00C2B6);

const Color gasUsageContainerStart = Color.fromRGBO(166, 204, 255, 0.4);
const Color gasUsageStartText = Color(0xFF384C66);
const Color gasUsageContainerEnd = Color.fromRGBO(194, 255, 166, 0.4);
const Color gasUsageEndText = Color(0xFF497442);

extension StringPath on String {
  String get path => "/$this";
  String get capitalize => "${substring(0, 1).toUpperCase()}${substring(1)}";
}

extension EexilyContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  GoRouter get router => GoRouter.of(this);
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
}

class Pages
{
  static String get home => "home";
  static String get splash => "splash";
  static String get onboard => "onboard";
  static String get carousel => "carousel";
  static String get register => "sign-up";
  static String get registerUser => "register-user";
  static String get registerBusiness => "register-business";
  static String get registerRider => "register-rider";
  static String get registerStation => "register-station";
  static String get registerSupport => "register-support";
  static String get chooseDriverImage => "choose-driver-image";
  static String get chooseBusinessCategory => "choose-business-category";
  static String get login => "sign-in";
  static String get verification => "verification";
  static String get scheduleRefill => "schedule-refill";
  static String get refillNow => "refill-now";
  static String get refill => "refill";
  static String get individualProfile => "individual-profile";
  static String get editIndividualProfile => "edit-individual-profile";
  static String get driverProfile => "driver-profile";
  static String get editDriverProfile => "edit-driver-profile";
  static String get gasUsage => 'gas-usage';
  static String get gasDetails => 'gas-details';
  static String get notification => "notification";
  static String get inbox => "inbox";
  static String get filter => "filter";
  static String get individualGasActivation => "individual-gas-activation";
  static String get individualOrderHistory => "individual-order-history";
  static String get orderHistory => "order-history";
  static String get viewSupportOrder => "view-support-order";
  static String get viewAttendantOrder => "view-attendant-order";
  static String get allAttendantOrders => "all-attendant-orders";
  static String get viewDriverOrder => "view-driver-order";
 }


const String loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque feugiat at risus sit amet scelerisque. Curabitur sollicitudin tincidunt erat, sed vehicula ligula ullamcorper at. In in tortor ipsum.";

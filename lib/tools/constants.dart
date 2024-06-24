import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color primary = Color(0xFF0054C2);
const Color secondary = Color(0xFFFFBE03);
const Color monokai = Color(0xFF0A0A0A);
const Color neutral = Color.fromARGB(35, 152, 152, 152);


extension StringPath on String {
  String get path => "/$this";
}

extension RedionesContext on BuildContext {
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
  static String get register => "register";
  static String get login => "login";
 }

const String loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque feugiat at risus sit amet scelerisque. Curabitur sollicitudin tincidunt erat, sed vehicula ligula ullamcorper at. In in tortor ipsum.";

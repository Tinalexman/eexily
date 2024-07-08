import 'package:eexily/pages/auth/login.dart';
import 'package:eexily/pages/auth/register.dart';
import 'package:eexily/pages/auth/verify.dart';
import 'package:eexily/pages/cooking/start_cooking.dart';
import 'package:eexily/pages/cooking/usage.dart';
import 'package:eexily/pages/home/home.dart';
import 'package:eexily/pages/home/notifications.dart';
import 'package:eexily/pages/home/onboard/onboard.dart';
import 'package:eexily/pages/home/splash.dart';
import 'package:eexily/pages/refill/refill_now.dart';
import 'package:eexily/pages/refill/schedule_refill.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';

final List<GoRoute> routes = [
  GoRoute(
    path: Pages.splash.path,
    name: Pages.splash,
    builder: (_, __) => const SplashPage(),
  ),
  GoRoute(
    path: Pages.onboard.path,
    name: Pages.onboard,
    builder: (_, __) => const OnboardingPage(),
  ),
  GoRoute(
    path: Pages.home.path,
    name: Pages.home,
    builder: (_, __) => const Homepage(),
  ),
  GoRoute(
    path: Pages.register.path,
    name: Pages.register,
    builder: (_, __) => const RegisterPage(),
  ),
  GoRoute(
    path: Pages.login.path,
    name: Pages.login,
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: Pages.verification.path,
    name: Pages.verification,
    builder: (_, state) => VerifyOTPPage(number: state.extra as String),
  ),
  GoRoute(
    path: Pages.notification.path,
    name: Pages.notification,
    builder: (_, __) => const NotificationsPage(),
  ),
  GoRoute(
    path: Pages.startCooking.path,
    name: Pages.startCooking,
    builder: (_, __) => const StartCookingPage(),
  ),
  GoRoute(
    path: Pages.usage.path,
    name: Pages.usage,
    builder: (_, __) => const UsagePage(),
  ),
  GoRoute(
    path: Pages.refillNow.path,
    name: Pages.refillNow,
    builder: (_, __) => const RefillNowPage(),
  ),
  GoRoute(
    path: Pages.scheduleRefill.path,
    name: Pages.scheduleRefill,
    builder: (_, __) => const ScheduleRefillPage(),
  ),
];

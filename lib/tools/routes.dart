import 'package:eexily/pages/auth/register.dart';
import 'package:eexily/pages/home/home.dart';
import 'package:eexily/pages/home/onboard/onboard.dart';
import 'package:eexily/pages/home/splash.dart';
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
];

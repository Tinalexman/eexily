import 'package:eexily/components/chat.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/points.dart';
import 'package:eexily/pages/auth/category.dart';
import 'package:eexily/pages/auth/login.dart';
import 'package:eexily/pages/auth/register.dart';
import 'package:eexily/pages/auth/verify.dart';
import 'package:eexily/pages/cooking/start_cooking.dart';
import 'package:eexily/pages/cooking/usage.dart';
import 'package:eexily/pages/home/common/leaderboard.dart';
import 'package:eexily/pages/home/common/notifications.dart';
import 'package:eexily/pages/home/common/points_saver.dart';
import 'package:eexily/pages/home/home.dart';
import 'package:eexily/pages/home/inbox.dart';
import 'package:eexily/pages/home/support/order_history.dart';
import 'package:eexily/pages/home/support/view_order.dart';
import 'package:eexily/pages/onboard/intro.dart';
import 'package:eexily/pages/onboard/onboard.dart';
import 'package:eexily/pages/onboard/splash.dart';
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
    path: Pages.inbox.path,
    name: Pages.inbox,
    builder: (_, state) => Inbox(conversation: state.extra as Conversation),
  ),
  GoRoute(
    path: "${Pages.register.path}/:type",
    name: Pages.register,
    builder: (_, state) {
      String type = state.pathParameters["type"] as String;
      return RegisterPage(type: type);
    },
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
  GoRoute(
    path: Pages.leaderboard.path,
    name: Pages.leaderboard,
    builder: (_, __) => const LeaderboardPage(),
  ),
  GoRoute(
    path: Pages.pointsSaver.path,
    name: Pages.pointsSaver,
    builder: (_, state) => PointsSaverPage(type: state.extra as PointType),
  ),
  GoRoute(
    path: Pages.carousel.path,
    name: Pages.carousel,
    builder: (_, __) => const CarouselPage(),
  ),
  GoRoute(
    path: Pages.chooseCategory.path,
    name: Pages.chooseCategory,
    builder: (_, __) => const ChooseCategoryPage(),
  ),
  GoRoute(
    path: Pages.orderHistory.path,
    name: Pages.orderHistory,
    builder: (_, __) => const OrderHistory(),
  ),
  GoRoute(
    path: Pages.viewOrder.path,
    name: Pages.viewOrder,
    builder: (_, state) => ViewOrder(order: state.extra as Order),
  ),
];

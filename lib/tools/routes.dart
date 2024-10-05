import 'package:eexily/components/chat.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/pages/auth/choose_business_category.dart';
import 'package:eexily/pages/auth/choose_driver_image.dart';
import 'package:eexily/pages/auth/create_account.dart';
import 'package:eexily/pages/auth/login.dart';
import 'package:eexily/pages/auth/register_business.dart';
import 'package:eexily/pages/auth/register_rider.dart';
import 'package:eexily/pages/auth/register_station.dart';
import 'package:eexily/pages/auth/register_support.dart';
import 'package:eexily/pages/auth/register_user.dart';
import 'package:eexily/pages/auth/verify.dart';
import 'package:eexily/pages/home/attendant/all_orders.dart';
import 'package:eexily/pages/home/attendant/view_order.dart';
import 'package:eexily/pages/home/common/filter.dart';
import 'package:eexily/pages/home/common/notifications.dart';
import 'package:eexily/pages/home/driver/view_order.dart';
import 'package:eexily/pages/home/home.dart';
import 'package:eexily/pages/home/inbox.dart';
import 'package:eexily/pages/home/regular/activation/activation.dart';
import 'package:eexily/pages/home/regular/gas_details.dart';
import 'package:eexily/pages/home/regular/gas_usage.dart';
import 'package:eexily/pages/home/regular/profile.dart';
import 'package:eexily/pages/home/support/order_history.dart';
import 'package:eexily/pages/home/support/view_order.dart';
import 'package:eexily/pages/onboard/intro.dart';
import 'package:eexily/pages/onboard/onboard.dart';
import 'package:eexily/pages/onboard/splash.dart';
import 'package:eexily/pages/refill/history.dart';
import 'package:eexily/pages/refill/refill.dart';
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
    path: Pages.gasUsage.path,
    name: Pages.gasUsage,
    builder: (_, __) => const GasUsagePage(),
  ),
  GoRoute(
    path: Pages.register.path,
    name: Pages.register,
    builder: (_, __) => const CreateAccountPage(),
  ),
  GoRoute(
    path: Pages.registerUser.path,
    name: Pages.registerUser,
    builder: (_, state) =>
        RegisterUserPage(initialDetails: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.registerBusiness.path,
    name: Pages.registerBusiness,
    builder: (_, state) => RegisterBusinessPage(
        initialDetails: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.registerRider.path,
    name: Pages.registerRider,
    builder: (_, state) =>
        RegisterRiderPage(initialDetails: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.registerSupport.path,
    name: Pages.registerSupport,
    builder: (_, state) => RegisterSupportPage(
        initialDetails: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.registerStation.path,
    name: Pages.registerStation,
    builder: (_, state) => RegisterGasStationPage(
        initialDetails: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.chooseDriverImage.path,
    name: Pages.chooseDriverImage,
    builder: (_, state) =>
        ChooseDriverImage(data: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: Pages.chooseBusinessCategory.path,
    name: Pages.chooseBusinessCategory,
    builder: (_, state) =>
        ChooseBusinessCategoryPage(initial: state.extra as String),
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
    path: Pages.refillNow.path,
    name: Pages.refillNow,
    builder: (_, __) => const RefillNowPage(),
  ),
  GoRoute(
    path: Pages.individualGasActivation.path,
    name: Pages.individualGasActivation,
    builder: (_, __) => const ActivationPages(),
  ),
  GoRoute(
    path: Pages.scheduleRefill.path,
    name: Pages.scheduleRefill,
    builder: (_, state) => ScheduleRefillPage(scheduledTime: state.extra as String),
  ),
  GoRoute(
    path: Pages.refill.path,
    name: Pages.refill,
    builder: (_, __) => const RefillPage(),
  ),
  GoRoute(
    path: Pages.carousel.path,
    name: Pages.carousel,
    builder: (_, __) => const CarouselPage(),
  ),
  GoRoute(
    path: Pages.orderHistory.path,
    name: Pages.orderHistory,
    builder: (_, __) => const OrderHistory(),
  ),
  GoRoute(
    path: Pages.gasDetails.path,
    name: Pages.gasDetails,
    builder: (_, __) => const GasDetailsPage(),
  ),
  GoRoute(
    path: Pages.individualProfile.path,
    name: Pages.individualProfile,
    builder: (_, __) => const IndividualProfilePage(),
  ),
  GoRoute(
    path: Pages.individualOrderHistory.path,
    name: Pages.individualOrderHistory,
    builder: (_, __) => const IndividualOrderHistory(),
  ),
  GoRoute(
    path: Pages.viewSupportOrder.path,
    name: Pages.viewSupportOrder,
    builder: (_, state) => ViewSupportOrder(order: state.extra as Order),
  ),
  GoRoute(
    path: Pages.allAttendantOrders.path,
    name: Pages.allAttendantOrders,
    builder: (_, __) => const AttendantAllOrdersPage(),
  ),
  GoRoute(
    path: Pages.viewAttendantOrder.path,
    name: Pages.viewAttendantOrder,
    builder: (_, state) => ViewAttendantOrder(order: state.extra as Order),
  ),
  GoRoute(
    path: Pages.filter.path,
    name: Pages.filter,
    builder: (_, __) => const FilterPage(),
  ),
  GoRoute(
    path: Pages.viewDriverOrder.path,
    name: Pages.viewDriverOrder,
    builder: (_, state) => ViewDriverOrder(order: state.extra as Order),
  )
];

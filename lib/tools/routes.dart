import 'package:eexily/components/chat.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/pages/auth/choose_business_category.dart';
import 'package:eexily/pages/auth/choose_driver_image.dart';
import 'package:eexily/pages/auth/create_account.dart';
import 'package:eexily/pages/auth/forgot_password.dart';
import 'package:eexily/pages/auth/login.dart';
import 'package:eexily/pages/auth/register_business.dart';
import 'package:eexily/pages/auth/register_merchant.dart';
import 'package:eexily/pages/auth/register_rider.dart';
import 'package:eexily/pages/auth/register_station.dart';
import 'package:eexily/pages/auth/register_support.dart';
import 'package:eexily/pages/auth/register_user.dart';
import 'package:eexily/pages/auth/reset_password.dart';
import 'package:eexily/pages/auth/select_bank.dart';
import 'package:eexily/pages/auth/setup_account.dart';
import 'package:eexily/pages/auth/verify.dart';
import 'package:eexily/pages/home/attendant/edit_profile.dart';
import 'package:eexily/pages/home/attendant/view_order.dart';
import 'package:eexily/pages/home/business/activation/activation.dart';
import 'package:eexily/pages/home/cheffy.dart';
import 'package:eexily/pages/home/common/help.dart';
import 'package:eexily/pages/home/common/notifications.dart';
import 'package:eexily/pages/home/driver/edit_profile.dart';
import 'package:eexily/pages/home/driver/view_order.dart';
import 'package:eexily/pages/home/home.dart';
import 'package:eexily/pages/home/inbox.dart';
import 'package:eexily/pages/home/merchant/edit_profile.dart';
import 'package:eexily/pages/home/merchant/view_order.dart';
import 'package:eexily/pages/home/refill/history.dart';
import 'package:eexily/pages/home/refill/refill_now.dart';
import 'package:eexily/pages/home/refill/schedule_refill.dart';
import 'package:eexily/pages/home/regular/activation/activation.dart';
import 'package:eexily/pages/home/regular/edit_profile.dart';
import 'package:eexily/pages/home/regular/gas_details.dart';
import 'package:eexily/pages/home/regular/gas_usage.dart';
import 'package:eexily/pages/home/regular/last_refill.dart';
import 'package:eexily/pages/home/regular/update_cylinder.dart';
import 'package:eexily/pages/home/support/order_history.dart';
import 'package:eexily/pages/home/support/view_order.dart';
import 'package:eexily/pages/onboard/intro.dart';
import 'package:eexily/pages/onboard/onboard.dart';
import 'package:eexily/pages/onboard/splash.dart';
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
    path: Pages.forgotPassword.path,
    name: Pages.forgotPassword,
    builder: (_, __) => const ForgotPasswordPage(),
  ),
  GoRoute(
    path: Pages.help.path,
    name: Pages.help,
    builder: (_, __) => const HelpPage(),
  ),
  GoRoute(
    path: Pages.resetPassword.path,
    name: Pages.resetPassword,
    builder: (_, state) => ResetPasswordPage(email: state.extra as String),
  ),
  GoRoute(
    path: Pages.registerUser.path,
    name: Pages.registerUser,
    builder: (_, state) => RegisterUserPage(userId: state.extra as String),
  ),
  GoRoute(
    path: Pages.registerBusiness.path,
    name: Pages.registerBusiness,
    builder: (_, __) => const RegisterBusinessPage(),
  ),
  GoRoute(
    path: Pages.registerMerchant.path,
    name: Pages.registerMerchant,
    builder: (_, state) => RegisterMerchantPage(userId: state.extra as String),
  ),
  GoRoute(
    path: Pages.registerRider.path,
    name: Pages.registerRider,
    builder: (_, state) => RegisterRiderPage(userId: state.extra as String),
  ),
  GoRoute(
    path: Pages.registerSupport.path,
    name: Pages.registerSupport,
    builder: (_, __) => const RegisterSupportPage(),
  ),
  GoRoute(
    path: Pages.registerStation.path,
    name: Pages.registerStation,
    builder: (_, state) => RegisterGasStationPage(userId: state.extra as String),
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
    builder: (_, state) =>
        LoginPage(savedDetails: state.extra as Map<String, String>?),
  ),
  GoRoute(
    path: Pages.verification.path,
    name: Pages.verification,
    builder: (_, state) =>
        VerifyOTPPage(config: state.extra as Map<String, String>),
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
    builder: (_, __) => const IndividualActivationPages(),
  ),
  GoRoute(
    path: Pages.businessGasActivation.path,
    name: Pages.businessGasActivation,
    builder: (_, __) => const BusinessActivationPages(),
  ),
  GoRoute(
    path: Pages.scheduleRefill.path,
    name: Pages.scheduleRefill,
    builder: (_, state) =>
        ScheduleRefillPage(scheduledTime: state.extra as String),
  ),
  GoRoute(
    path: Pages.setupAccount.path,
    name: Pages.setupAccount,
    builder: (_, state) =>
        SetupAccountPage(userData: state.extra as List<String>),
  ),
  GoRoute(
    path: Pages.selectBank.path,
    name: Pages.selectBank,
    builder: (_, state) => SelectBankPage(current: state.extra as String),
  ),
  GoRoute(
    path: Pages.cheffy.path,
    name: Pages.cheffy,
    builder: (_, __) => const CheffyPage(),
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
    path: Pages.editIndividualProfile.path,
    name: Pages.editIndividualProfile,
    builder: (_, __) => const EditIndividualProfilePage(),
  ),
  GoRoute(
    path: Pages.editDriverProfile.path,
    name: Pages.editDriverProfile,
    builder: (_, __) => const EditRiderProfilePage(),
  ),
  GoRoute(
    path: Pages.editMerchantProfile.path,
    name: Pages.editMerchantProfile,
    builder: (_, __) => const EditMerchantProfilePage(),
  ),
  GoRoute(
    path: Pages.editAttendantProfile.path,
    name: Pages.editAttendantProfile,
    builder: (_, __) => const EditAttendantProfilePage(),
  ),
  GoRoute(
    path: Pages.lastRefill.path,
    name: Pages.lastRefill,
    builder: (_, __) => const LastRefillPage(),
  ),
  GoRoute(
    path: Pages.updateCylinder.path,
    name: Pages.updateCylinder,
    builder: (_, __) => const UpdateCylinderPage(),
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
    path: Pages.viewAttendantOrder.path,
    name: Pages.viewAttendantOrder,
    builder: (_, state) => ViewAttendantOrder(order: state.extra as Order),
  ),
  GoRoute(
    path: Pages.viewMerchantOrder.path,
    name: Pages.viewMerchantOrder,
    builder: (_, state) => ViewMerchantOrder(order: state.extra as Order),
  ),
  GoRoute(
    path: Pages.viewDriverOrder.path,
    name: Pages.viewDriverOrder,
    builder: (_, state) => ViewDriverOrder(order: state.extra as Order),
  ),
];

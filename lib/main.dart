import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eexily/components/notification.dart' as n;
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as time;

import 'api/base.dart';
import 'components/order.dart';
import 'controllers/notifications.dart';
import 'database.dart';
import 'tools/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'gas_feel_notification_channel_group',
        channelKey: 'gas_feel_notification_channel_key',
        channelName: 'Gas Feel',
        channelShowBadge: true,
        channelDescription: 'Notification channel',
        defaultColor: primary,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        // playSound: true,
        // soundSource: 'resource://raw/gas_feel',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'gas_feel_notification_channel_group',
        channelGroupName: 'GasFeel Notification Group',
      )
    ],
    debug: true,
  );

  await ScreenUtil.ensureScreenSize();
  await DatabaseManager.init();
  await DatabaseManager.clearAllMessages();

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications()
        .requestPermissionToSendNotifications(permissions: [
      NotificationPermission.Alert,
      NotificationPermission.Sound,
      NotificationPermission.Badge,
      NotificationPermission.Vibration,
      NotificationPermission.Light,
      NotificationPermission.FullScreenIntent,
    ]);
  }

  runApp(const ProviderScope(child: Eexily()));
}

class Eexily extends ConsumerStatefulWidget {
  static late WidgetRef globalRef;
  const Eexily({super.key});

  @override
  ConsumerState<Eexily> createState() => _EexilyState();
}

class _EexilyState extends ConsumerState<Eexily> {
  late GoRouter _router;
  late WidgetRef globalRef;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: Pages.splash.path,
      routes: routes,
    );

    Eexily.globalRef = ref;

    time.setDefaultLocale('en_short');

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
      NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceivedMethod,
    );

    initializeAPIServices();
    setupSocketHandlers();
  }


  void setupSocketHandlers() {
    addHandler(notificationSignal, (dynamic data) {

      n.Notification notification = n.Notification.fromJson(data);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notification.message.hashCode,
          channelKey: 'gas_feel_notification_channel_key',
          actionType: ActionType.Default,
          title: notification.actionLabel,
          body: notification.message,
          fullScreenIntent: true,
          wakeUpScreen: true,
        ),
      );
      List<n.Notification> notifications = ref.watch(notificationsProvider);
      ref.watch(notificationsProvider.notifier).state = [
        notification,
        ...notifications,
      ];

      if (notification.actionLabel == "Order Status") {
        List<Order> userOrders = ref.watch(initialExpressOrdersProvider);
        if (userOrders.isNotEmpty) {
          Order order = userOrders.first;
          List<OrderStates> states = order.states;
          OrderState newState = convertState(notification.notificationType);
          states.add(
            OrderStates(
              state: newState,
              timestamp: notification.timestamp.toIso8601String(),
            ),
          );

          ref.watch(initialExpressOrdersProvider.notifier).state = [
            order.copyWith(
              status: notification.notificationType,
              states: states,
            ),
            ...(userOrders.sublist(1)),
          ];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, widget) => MaterialApp.router(
        title: 'Gas Feel',
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          fontFamily: "WorkSans",
          useMaterial3: true,
          scheme: FlexScheme.bahamaBlue,
          background: Colors.white,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          appBarElevation: 0.0,
          scaffoldBackground: const Color(0xFFF9F9F9),
        ),
        routerConfig: _router,
      ),
      splitScreenMode: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
    );
  }
}

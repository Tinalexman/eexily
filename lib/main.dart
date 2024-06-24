import 'package:eexily/tools/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as time;

import 'tools/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await ScreenUtil.ensureScreenSize();

  runApp(const ProviderScope(child: Eexily()));
}

class Eexily extends StatefulWidget {
  const Eexily({super.key});

  @override
  State<Eexily> createState() => _EexilyState();
}

class _EexilyState extends State<Eexily> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: Pages.splash.path,
      routes: routes,
    );
    time.setDefaultLocale('en_short');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, widget) => MaterialApp.router(
        title: 'Rediones',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          fontFamily: "Poppins",
          useMaterial3: true,
          scheme: FlexScheme.bahamaBlue,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          appBarElevation: 0.0,
          scaffoldBackground: const Color(0xFFF9F9F9),
        ),
        darkTheme: FlexThemeData.dark(
          fontFamily: "Poppins",
          useMaterial3: true,
          scheme: FlexScheme.bahamaBlue,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          appBarElevation: 0.0,
        ),
        routerConfig: _router,
      ),
      splitScreenMode: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
    );
  }
}

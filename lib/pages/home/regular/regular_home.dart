import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'drawer.dart';
import 'home.dart';

class RegularHome extends ConsumerStatefulWidget {
  const RegularHome({super.key});

  @override
  ConsumerState<RegularHome> createState() => _RegularHomeState();
}

class _RegularHomeState extends ConsumerState<RegularHome> {
  late List<Widget> children;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
    ];
  }



  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);
    User user = ref.watch(userProvider) as User;

    return Scaffold(
      key: scaffoldKey,
      drawer: EexilyUserDrawer(
        onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: Icon(
            IconsaxPlusBroken.menu_1,
            size: 26.r,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(user.image),
          ),
          IconButton(
            onPressed: () => context.router.pushNamed(Pages.notification),
            icon: const Icon(
              IconsaxPlusBroken.notification_1,
              color: monokai,
            ),
            iconSize: 26.r,
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: children,
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              backgroundColor: primary,
              child: Icon(
                IconsaxPlusBroken.play,
                color: Colors.white,
                size: 32.r,
              ),
              elevation: 1.0,
              onPressed: () {},
            )
          : null,
    );
  }
}

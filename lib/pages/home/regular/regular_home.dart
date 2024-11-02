import 'package:eexily/pages/refill/refill.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void navigateToPage(int newPage) {
    if (newPage == 1) {
      context.router.pushNamed(Pages.refill);
    } else if (newPage == 3) {
      context.router.pushNamed(Pages.devices);
    } else if (newPage == 4) {
      context.router.pushNamed(Pages.individualProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);

    return BackButtonListener(
      onBackButtonPressed: () async {
        return !context.router.canPop();
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: EexilyUserDrawer(
          onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
        ),
        body: IndexedStack(
          index: index,
          children: [
            Home(
              scaffoldKey: scaffoldKey,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          selectedItemColor: primary,
          unselectedItemColor: neutral3,
          onTap: navigateToPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.home,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.home,
                size: 22.r,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.gas_station,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.gas_station,
                size: 22.r,
              ),
              label: "Refill",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/Cheffy.gif",
                width: 30.r,
                fit: BoxFit.cover,
              ),
              label: "Ask Cheffy",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.devices,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.devices,
                size: 22.r,
              ),
              label: "Devices",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusBroken.profile,
                size: 22.r,
              ),
              activeIcon: Icon(
                IconsaxPlusBold.profile,
                size: 22.r,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

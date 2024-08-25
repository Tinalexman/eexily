import 'package:eexily/pages/home/support/chat.dart';
import 'package:eexily/pages/home/support/home.dart';
import 'package:eexily/pages/home/support/profile.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportHome extends ConsumerStatefulWidget {
  const SupportHome({super.key});

  @override
  ConsumerState<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends ConsumerState<SupportHome> {
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    children = const [
      Home(),
      Chats(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (val) => ref.watch(pageIndexProvider.notifier).state = val,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              width: 20.r,
              height: 20.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
              ),
              child: SvgPicture.asset("assets/images/Home Inactive.svg"),
            ),
            activeIcon: Container(
              alignment: Alignment.center,
              width: 20.r,
              height: 20.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primary,
              ),
              child: SvgPicture.asset("assets/images/Home Active.svg"),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/Chat Active.svg"),
            activeIcon: SvgPicture.asset("assets/images/Chat Inactive.svg"),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/Profile Inactive.svg"),
            activeIcon: SvgPicture.asset("assets/images/Profile Active.svg"),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

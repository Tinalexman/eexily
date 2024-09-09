import 'package:eexily/pages/home/support/chat.dart';
import 'package:eexily/pages/home/support/home.dart';
import 'package:eexily/pages/home/support/profile.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
        selectedItemColor: primary,
        unselectedItemColor: neutral3,
        onTap: (val) => ref.watch(pageIndexProvider.notifier).state = val,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              IconsaxPlusBroken.gift,
              size: 22.r,
            ),
            activeIcon: Icon(
              IconsaxPlusBold.gift,
              size: 22.r,
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconsaxPlusBroken.message,
              size: 22.r,
            ),
            activeIcon: Icon(
              IconsaxPlusBold.message,
              size: 22.r,
            ),
            label: "Chats",
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
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/pages/home/regular/refill/refill.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../common/drawer.dart';
import 'devices.dart';
import 'home.dart';
import 'profile.dart';

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
      Refill(),
      Devices(),
      Profile(),
    ];
  }

  String get titleText {
    int index = ref.watch(pageIndexProvider);
    switch (index) {
      case 1:
        return "Refill Gas";
      case 2:
        return "Devices";
      case 3:
        return "Profile";
      default:
        return "";
    }
  }

  List<Widget> get actions {
    User user = ref.watch(userProvider) as User;
    int index = ref.watch(pageIndexProvider);
    return [
      if (index == 0)
        GestureDetector(
          onTap: () => ref.watch(pageIndexProvider.notifier).state = 3,
          child: CachedNetworkImage(
            imageUrl: user.image,
            errorWidget: (_, __, ___) => CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.redAccent,
              child: Center(
                child: Icon(
                  IconsaxPlusBold.gallery_slash,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
            progressIndicatorBuilder: (_, __, ___) => CircleAvatar(
              radius: 20.r,
              backgroundColor: primary50,
            ),
            imageBuilder: (_, provider) => CircleAvatar(
              radius: 20.r,
              backgroundImage: provider,
            ),
          ),
        ),
      if (index != 2)
        IconButton(
          onPressed: () {
            if (index == 0) {
              context.router.pushNamed(Pages.notification);
            } else if (index == 1) {
              context.router.pushNamed(Pages.individualOrderHistory);
            } else if (index == 3) {
              context.router.pushNamed(Pages.editIndividualProfile);
            }
          },
          icon: Icon(
            index == 0
                ? IconsaxPlusBroken.notification_1
                : index == 1
                    ? IconsaxPlusBroken.chart_2
                    : IconsaxPlusBroken.edit_2,
            color: monokai,
          ),
          iconSize: 26.r,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(pageIndexProvider);

    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if (!canPop) {
          ref.watch(pageIndexProvider.notifier).state = 0;
        }
        return !canPop;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: EexilyUserDrawer(
          onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: index == 0
              ? GestureDetector(
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  child: Icon(
                    IconsaxPlusBroken.menu_1,
                    size: 26.r,
                  ),
                )
              : Text(
                  titleText,
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
          actions: actions,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: IndexedStack(
              index: index,
              children: children,
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }
}

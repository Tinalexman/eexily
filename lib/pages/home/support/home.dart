import 'package:eexily/components/user/support.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    Support support = ref.watch(userProvider) as Support;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: const Color(0xFF7C462F),
              child: Text(
                support.firstName.substring(0, 1).toUpperCase(),
                style: context.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Hello, ${support.firstName}",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.router.pushNamed(Pages.notification),
            icon: const FaIcon(FontAwesomeIcons.bell),
            iconSize: 26.r,
          )
        ],
      ),


    );
  }
}

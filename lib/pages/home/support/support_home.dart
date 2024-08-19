import 'package:eexily/components/user/support.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_flutter/icons_flutter.dart';

class SupportHome extends ConsumerStatefulWidget {
  const SupportHome({super.key});

  @override
  ConsumerState<SupportHome> createState() => _SupportHomeState();
}

class _SupportHomeState extends ConsumerState<SupportHome> {
  final TextEditingController controller = TextEditingController();



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                support.name.substring(0, 1).toUpperCase(),
                style: context.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Hello, ${support.name}",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.router.pushNamed(Pages.notification),
            icon: const Icon(FontAwesome5.bell),
            iconSize: 26.r,
          )
        ],
      ),
    );
  }
}

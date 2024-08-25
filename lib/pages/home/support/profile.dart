import 'package:eexily/components/user/support.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  late Color background, text;

  @override
  void initState() {
    super.initState();
    String name = ref.read(userProvider.select((value) => value.firstName));
    background = randomColor(name);
    text = chooseTextColor(background);
  }



  @override
  Widget build(BuildContext context) {
    Support support = ref.watch(userProvider) as Support;


    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if(!canPop) {
          ref.watch(pageIndexProvider.notifier).state = 0;

        }
        return !canPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: background,
                  child: Text(
                    support.firstName.substring(0, 1).toUpperCase(),
                    style: context.textTheme.displayLarge!.copyWith(
                      color: text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "${support.firstName} ${support.lastName}",
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  support.email,
                  style: context.textTheme.bodyLarge,
                ),
                Text(
                  support.supportRole,
                  style: context.textTheme.bodyMedium,
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        logout(ref);
                        context.router.goNamed(Pages.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5.r)
                        ),
                        side: const BorderSide(color: primary),
                        fixedSize: Size(130.w, 40.h),
                        minimumSize: Size(130.w, 40.h),
                      ),
                      child: Text(
                        "Sign out",
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      onPressed: () => ref.watch(pageIndexProvider.notifier).state = 0,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.5.r)
                        ),

                        fixedSize: Size(130.w, 40.h),
                        minimumSize: Size(130.w, 40.h),
                      ),
                      child: Text(
                        "Go home",
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

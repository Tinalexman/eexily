import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  Widget build(BuildContext context) {
    String firstName = ref.watch(userProvider.select((u) => u.firstName));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0.h,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: neutral2,
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello $firstName",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Welcome",
                        style: context.textTheme.bodyMedium,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 60.h),
              const GasTrackerContainer(),
              SizedBox(height: 450.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 1.0,
                  fixedSize: Size(375.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.5.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Start Cooking",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

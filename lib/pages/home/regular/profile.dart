import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider) as User;
    int gasSize = ref.watch(gasCylinderSizeProvider);
    int gasPercentage = ref.watch(gasLevelProvider);
    bool active = ref.watch(playGasAnimationProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Profile",
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () =>
                  context.router.pushNamed(Pages.editIndividualProfile),
              icon: Icon(
                IconsaxPlusBroken.edit,
                color: monokai,
                size: 24.r,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: user.image,
                  errorWidget: (_, __, ___) => Container(
                    width: 375.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  progressIndicatorBuilder: (_, __, ___) => Container(
                    width: 375.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: primary50,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  imageBuilder: (_, provider) => Container(
                    width: 375.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: primary50,
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        image: provider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  user.fullName,
                  style: context.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: monokai,
                  ),
                ),
                Text(
                  user.email,
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: neutral2,
                  ),
                ),
                Text(
                  user.phoneNumber,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: monokai,
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cylinder Size",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: monokai,
                      ),
                    ),
                    Text(
                      "${gasSize}kg",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: monokai,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gas Level",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: monokai,
                      ),
                    ),
                    Text(
                      "$gasPercentage%",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: gasColor(gasPercentage * 0.01),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gas Tracking",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: monokai,
                      ),
                    ),
                    Text(
                      active ? "Active" : "Inactive",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: active ? primary : neutral3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

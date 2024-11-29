import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/components/user/merchant.dart';
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
    Merchant merchant = ref.watch(userProvider) as Merchant;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: merchant.image,
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
            merchant.fullName,
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          Text(
            merchant.email,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: neutral2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Phone: ${merchant.phoneNumber}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Location: ${merchant.location}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Store Name: ${merchant.storeName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Account Information",
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Account Name: ${merchant.accountName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Bank Name: ${merchant.bankName}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Account Number: ${merchant.accountNumber}",
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: monokai,
            ),
          ),
        ],
      ),
    );
  }
}

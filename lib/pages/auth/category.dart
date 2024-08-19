import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  final List<String> options = [
    "Business",
    "Individual/Household",
    "Driver/Rider",
    "Gas Station Attendant"
  ];

  int choice = -1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 10.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Image.asset(
                  "assets/images/BlueLogoAndText.png",
                  width: 120.w,
                ),
                SizedBox(height: 5.h),
                Text(
                  "Choose your Category",
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 50.h),
                SizedBox(
                  width: 375.w,
                  height:
                      (options.length * 50.h) + ((options.length - 1) * 20.h),
                  child: ListView.separated(
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () => setState(() => choice = index),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              choice == index ? Border.all(color: primary) : null,
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        child: SizedBox(
                          width: 375.w,
                          height: 50.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 15.h,
                            ),
                            child: Text(
                              options[index],
                              style: context.textTheme.titleSmall!.copyWith(
                                color: choice == index ? primary : null,
                                fontWeight: choice == index
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemCount: options.length,
                  ),
                ),
                SizedBox(height: 50.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(375.w, 50.h),
                    fixedSize: Size(375.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5.r),
                    ),
                    elevation: 1.0,
                    backgroundColor: choice == -1 ? primary.withOpacity(0.6) : primary,
                  ),
                  onPressed: () {
                    if(choice == -1) return;
                    context.router.pushNamed(Pages.register, pathParameters: {"type": options[choice]});
                  },
                  child: Text(
                    "Continue",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

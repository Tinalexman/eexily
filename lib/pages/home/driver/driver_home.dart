import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:eexily/tools/widgets/driver.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class DriverHome extends ConsumerStatefulWidget {
  const DriverHome({super.key});

  @override
  ConsumerState<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends ConsumerState<DriverHome> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Driver driver = ref.watch(userProvider) as Driver;
    List<Order> driverOrders = ref.watch(driverOrdersProvider);

    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(driver.image),
          ),
          SizedBox(width: 10.w),
          Text(
            "Hello, ${driver.firstName}",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.router.pushNamed(Pages.notification),
          icon: const Icon(
            IconsaxPlusBroken.notification_1,
            color: monokai,
          ),
          iconSize: 26.r,
        )
      ],
    ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpecialForm(
                controller: controller,
                width: 375.w,
                hint: "Search orders",
                prefix: Icon(
                  IconsaxPlusBroken.search_normal,
                  color: const Color(0xFFA9A9A9),
                  size: 20.r,
                ),
                fillColor: const Color(0xFFF4F4F4),
              ),
              SizedBox(height: 20.h),
              Text(
                "Orders of the day",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: monokai,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) =>
                      d.OrderContainer(order: driverOrders[index]),
                  padding: const EdgeInsets.all(1),
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemCount: driverOrders.length,
                  physics: const BouncingScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

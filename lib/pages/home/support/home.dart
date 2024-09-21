import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late Color background, text;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    String name = ref.read(userProvider.select((value) => value.firstName));
    background = randomColor(name);
    text = chooseTextColor(background);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Support support = ref.watch(userProvider) as Support;
    List<Order> pendingOrders = ref.watch(pendingOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => ref.watch(pageIndexProvider.notifier).state = 2,
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: background,
                child: Text(
                  support.firstName.substring(0, 1).toUpperCase(),
                  style: context.textTheme.titleLarge!.copyWith(
                    color: text,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Orders of the day",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: monokai,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.router.pushNamed(Pages.orderHistory),
                    child: Text(
                      "View History",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  itemBuilder: (_, index) => OrderContainer(
                    order: pendingOrders[index],
                    link: Pages.viewSupportOrder,
                  ),
                  padding: const EdgeInsets.all(1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 165.h,
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: pendingOrders.length,
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

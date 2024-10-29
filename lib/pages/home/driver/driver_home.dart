import 'package:cached_network_image/cached_network_image.dart';
import 'package:eexily/api/rider.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:eexily/tools/widgets/driver.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'drawer.dart';

class DriverHome extends ConsumerStatefulWidget {
  const DriverHome({super.key});

  @override
  ConsumerState<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends ConsumerState<DriverHome> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool loading = true;

 @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getRiderOrders);
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Future<void> getRiderOrders() async {
   String id = ref.watch(userProvider.select((u) => u.id));
    var response = await getIncomingOrders(id);
    showMessage(response.message);
    setState(() => loading = false);
    if(!response.status) return;

    ref.watch(driverOrdersProvider.notifier).state = response.payload;
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    Driver driver = ref.watch(userProvider) as Driver;
    List<Order> driverOrders = ref.watch(driverOrdersProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: EexilyUserDrawer(
        onCloseDrawer: () => scaffoldKey.currentState?.closeDrawer(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: Icon(
            IconsaxPlusBroken.menu_1,
            size: 26.r,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.router.pushNamed(Pages.driverProfile),
            child: CachedNetworkImage(
              imageUrl: driver.image,
              errorWidget: (_, __, ___) => CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.redAccent,
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
              if (loading)
                Expanded(
                  child: Skeletonizer(
                    child: ListView.separated(
                      itemBuilder: (_, __) {
                        return d.OrderContainer(
                          order: dummyOrder,
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemCount: 6,
                    ),
                  ),
                ),
              if (!loading && driverOrders.isEmpty)
                Expanded(
                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/error.png",
                          width: 200.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "You do not have any incoming orders",
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            setState(() => loading = true);
                            getRiderOrders();
                          },
                          child: Text(
                            "Click here to refresh",
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (!loading && driverOrders.isNotEmpty)
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

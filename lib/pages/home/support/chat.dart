import 'dart:math';

import 'package:eexily/components/chat.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:eexily/tools/widgets/chats.dart';
import 'package:faker/faker.dart' as fk;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chats extends ConsumerStatefulWidget {
  const Chats({super.key});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  int tab = 0;
  final TextEditingController controller = TextEditingController();

  late List<Conversation> userConversations, driverConversations;

  @override
  void initState() {
    super.initState();

    fk.Faker faker = fk.Faker();
    Random random = Random(DateTime.now().millisecondsSinceEpoch);

    userConversations = List.generate(
      20,
      (index) => Conversation(
        timestamp: DateTime.now(),
        name: "${faker.person.firstName()} ${faker.person.lastName()}",
        id: "User Conversation ID: $index",
        image: "assets/images/user.png",
        lastMessage: faker.lorem.sentence(),
        active: random.nextBool(),
        messageCount: random.nextInt(10),
      ),
    );

    driverConversations = List.generate(
      20,
      (index) {
        return Conversation(
          timestamp: DateTime.now(),
          name: "${faker.person.firstName()} ${faker.person.lastName()}",
          id: "Driver Conversation ID: $index",
          lastMessage: faker.lorem.sentence(),
          active: random.nextBool(),
          messageCount: random.nextInt(10),
          code: randomGCode,
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if (!canPop) {
          ref.watch(pageIndexProvider.notifier).state = 0;
        }
        return !canPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Chats",
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => tab = 0),
                      child: Container(
                        width: 160.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            color: tab == 0 ? primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.h),
                            border:
                                tab != 0 ? Border.all(color: primary) : null),
                        alignment: Alignment.center,
                        child: Text(
                          "Users",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: tab == 0 ? Colors.white : primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => tab = 1),
                      child: Container(
                        width: 160.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            color: tab == 1 ? primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.h),
                            border:
                                tab != 1 ? Border.all(color: primary) : null),
                        alignment: Alignment.center,
                        child: Text(
                          "Rider/Drivers",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: tab == 1 ? Colors.white : primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SpecialForm(
                  controller: controller,
                  width: 375.w,
                  height: 40.h,
                  hint: "Search orders",
                  prefix: Icon(
                    Icons.search_rounded,
                    color: const Color(0xFFA9A9A9),
                    size: 20.r,
                  ),
                  fillColor: const Color(0xFFF4F4F4),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        if ((tab == 0 && index == userConversations.length) ||
                            (tab == 1 && index == driverConversations.length)) {
                          return SizedBox(height: 60.h);
                        }

                        List<Conversation> conversations =
                            tab == 0 ? userConversations : driverConversations;
                        return ConversationContainer(
                          conversation: conversations[index],
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemCount: tab == 0
                          ? userConversations.length + 1
                          : driverConversations.length + 1,
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

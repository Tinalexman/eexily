import 'dart:math';

import 'package:eexily/components/chat.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:faker/faker.dart' as fk;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Chats extends ConsumerStatefulWidget {
  const Chats({super.key});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
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
        lastMessage: faker.lorem.sentence(),
        active: random.nextBool(),
        messageCount: random.nextInt(10),
        code: randomGCode,
      ),
    );

    driverConversations = List.generate(
      20,
      (index) {
        return Conversation(
          timestamp: DateTime.now(),
          name: "${faker.person.firstName()} ${faker.person.lastName()}",
          id: "Driver Conversation ID: $index",
          image: "assets/images/man.png",
          lastMessage: faker.lorem.sentence(),
          active: random.nextBool(),
          messageCount: random.nextInt(10),
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Chats",
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 5.h,
              ),
              child: Column(
                children: [
                  SpecialForm(
                    controller: controller,
                    width: 375.w,
                    hint: "Search conversations",
                    prefix: Icon(
                      IconsaxPlusBroken.search_normal,
                      color: const Color(0xFFA9A9A9),
                      size: 20.r,
                    ),
                    fillColor: const Color(0xFFF4F4F4),
                  ),
                  SizedBox(height: 5.h),
                  TabBar(
                    tabs: const [
                      Tab(text: "Users"),
                      Tab(text: "Riders/Drivers"),
                    ],
                    labelColor: primary,
                    labelStyle: context.textTheme.bodyLarge,
                    unselectedLabelColor: neutral2,
                    indicatorColor: primary,
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {},
                          child: ListView.separated(
                            itemBuilder: (_, index) => ConversationContainer(
                              conversation: userConversations[index],
                            ),
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemCount: userConversations.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(1),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {},
                          child: ListView.separated(
                            itemBuilder: (_, index) => ConversationContainer(
                              conversation: driverConversations[index],
                            ),
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemCount: driverConversations.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

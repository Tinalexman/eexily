import 'dart:developer';

import 'package:eexily/api/cheffy.dart';
import 'package:eexily/components/cheffy_message.dart';
import 'package:eexily/database.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:timeago/timeago.dart' as time;

class CheffyPage extends ConsumerStatefulWidget {
  const CheffyPage({super.key});

  @override
  ConsumerState<CheffyPage> createState() => _CheffyPageState();
}

class _CheffyPageState extends ConsumerState<CheffyPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final FocusNode focusNode = FocusNode();

  final List<CheffyMessage> messages = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      List<CheffyMessage> localMessages = await DatabaseManager.getMessages();
      messages.addAll(localMessages);
      setState(() => loading = false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    var response = await sendMessageToCheffy(messages);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/Cheffy.gif",
              width: 35.r,
            ),
            SizedBox(width: 5.w),
            Text(
              "Cheffy",
              style: context.textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFD9D9D9).withOpacity(0.2),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: messages.isEmpty ?  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                Image.asset(
                  "assets/images/error.png",
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30.h),
                Text(
                  "Oops :(",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.h),
                Text(
                  "You have not sent any messages to Cheffy yet!.",
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontFamily: "WorkSans",
                  ),
                ),
              ],
            ),
          ) : ListView.separated(
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == messages.length) {
                return SizedBox(height: 50.h);
              }

              CheffyMessage message = messages[index];

              return Align(
                alignment: message.role == userRole
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 280.w,
                  ),
                  child: Stack(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color:
                              message.role == userRole ? primary : Colors.white,
                          borderRadius: BorderRadius.circular(7.5.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            right: 10.w,
                            top: 6.h,
                            bottom: 18.h,
                          ),
                          child: Text(
                            message.content,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: message.role == userRole
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 3.h,
                        right: 10.w,
                        child: Text(
                          time.format(message.timestamp),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: message.role == userRole
                                ? Colors.white70
                                : Colors.black45,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 15.h),
            itemCount: messages.length + 1,
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50.h,
                child: SpecialForm(
                  width: 390.w,
                  allowHeightExpand: true,
                  radius: BorderRadius.circular(200.h),
                  controller: textController,
                  borderColor: Colors.transparent,
                  hint: "Message",
                  fillColor: const Color(0xFFEFEFEF),
                  style: context.textTheme.bodyMedium,
                  suffix: loading
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(
                            color: primary,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            String controllerText = textController.text.trim();
                            if (controllerText.isEmpty) return;
                            CheffyMessage newMessage = CheffyMessage(
                              timestamp: DateTime.now(),
                              content: controllerText,
                              role: userRole,
                            );
                            textController.clear();
                            scrollController.animateTo(
                              1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );

                            messages.add(newMessage);
                            DatabaseManager.addMessage(newMessage);
                            setState(() => loading = true);
                            sendMessage();
                          },
                          child: Icon(
                            IconsaxPlusBold.send_2,
                            color: primary,
                            size: 26.r,
                          ),
                        ),
                  focus: focusNode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

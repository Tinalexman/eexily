import 'package:eexily/components/chat.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:badges/badges.dart' as bg;

class ConversationContainer extends StatelessWidget {
  final Conversation conversation;

  const ConversationContainer({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 70.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5.r),
        color: const Color(0xFFD9D9D9).withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: AssetImage(conversation.image),
                  ),
                  Positioned(
                    bottom: 0.h,
                    right: 2.w,
                    child: CircleAvatar(
                      radius: 5.r,
                      backgroundColor: conversation.active
                          ? const Color(0xFF00E117)
                          : const Color(0xFF898A8D),
                    ),
                  )
                ],
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 200.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conversation.name,
                      style: context.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      conversation.lastMessage,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF898A8D),
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time.format(conversation.timestamp),
                style: context.textTheme.bodySmall!.copyWith(
                  color: const Color(0xFF898A8D),
                ),
              ),
              if (conversation.messageCount > 0)
                bg.Badge(
                  badgeStyle: bg.BadgeStyle(
                    badgeColor: primary,
                    borderRadius: BorderRadius.circular(1000)
                  ),
                  badgeContent: Text(
                    "${conversation.messageCount}",
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

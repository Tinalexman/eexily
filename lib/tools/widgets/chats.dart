import 'package:badges/badges.dart' as bg;
import 'package:eexily/components/chat.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as time;

class ConversationContainer extends StatefulWidget {
  final Conversation conversation;

  const ConversationContainer({
    super.key,
    required this.conversation,
  });

  @override
  State<ConversationContainer> createState() => _ConversationContainerState();
}

class _ConversationContainerState extends State<ConversationContainer> {
  late Color background, text;

  @override
  void initState() {
    super.initState();
    background = randomColor(widget.conversation.id);
    text = chooseTextColor(background);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed(
        Pages.inbox,
        extra: widget.conversation,
      ),
      child: Container(
        width: 375.w,
        height: 70.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
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
                      backgroundImage: widget.conversation.image != null
                          ? AssetImage(widget.conversation.image!)
                          : null,
                      backgroundColor:
                          widget.conversation.image == null ? background : null,
                      child: widget.conversation.image == null
                          ? Center(
                              child: Text(
                                widget.conversation.name.substring(0, 1),
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: text,
                                ),
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0.h,
                      right: 2.w,
                      child: CircleAvatar(
                        radius: 5.r,
                        backgroundColor: widget.conversation.active
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.conversation.name,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: monokai,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.conversation.code != null)
                              TextSpan(
                                text: "   ${widget.conversation.code}",
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        widget.conversation.lastMessage,
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
                  time.format(widget.conversation.timestamp),
                  style: context.textTheme.bodySmall!.copyWith(
                    color: const Color(0xFF898A8D),
                  ),
                ),
                if (widget.conversation.messageCount > 0)
                  bg.Badge(
                    badgeStyle: bg.BadgeStyle(
                        badgeColor: primary,
                        borderRadius: BorderRadius.circular(1000)),
                    badgeContent: Text(
                      "${widget.conversation.messageCount}",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

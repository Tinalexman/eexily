import 'package:eexily/components/chat.dart';
import 'package:eexily/tools/constants.dart';
import 'package:eexily/tools/functions.dart';
import 'package:eexily/tools/providers.dart';
import 'package:eexily/tools/widgets.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:timeago/timeago.dart' as time;

class Inbox extends ConsumerStatefulWidget {
  final Conversation conversation;

  const Inbox({super.key, required this.conversation});

  @override
  ConsumerState<Inbox> createState() => _InboxState();
}

class _InboxState extends ConsumerState<Inbox>
    with SingleTickerProviderStateMixin {
  late Color background, text;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late AnimationController animationController;
  late Animation<double> animation;

  final FocusNode focusNode = FocusNode();

  String otherID = "otherID";
  late String currentID;

  late List<Message> messages;

  @override
  void initState() {
    super.initState();
    background = randomColor(widget.conversation.id);
    text = chooseTextColor(background);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        animationController.reverse();
      }
    });

    currentID = ref.read(userProvider.select((value) => value.id));

    messages = [
      Message(
        timestamp: DateTime.now(),
        sender: otherID,
        message: "Hello, Good morning",
      ),
      Message(
        timestamp: DateTime.now(),
        sender: currentID,
        message: "Hello, welcome to Eexily. How can we help you?",
      ),
      Message(
        timestamp: DateTime.now(),
        sender: otherID,
        message:
            "Pls i scheduled a gas refill last week and it was meant to be delivered yesterday but up till now have not received anything",
      ),
      Message(
        timestamp: DateTime.now(),
        sender: currentID,
        message:
            "Hello, apologies for the delay, we would check into it as soon as possible?",
      ),
    ];
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    textController.dispose();
    super.dispose();
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
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.conversation.name,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.conversation.code != null)
                  Text(
                    "G-code: ${widget.conversation.code}",
                    style: context.textTheme.bodySmall!.copyWith(
                      color: const Color(0xFFFBFF45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              IconsaxPlusBold.call,
              color: Colors.white,
            ),
            iconSize: 26.r,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            unFocus();
            animationController.reverse();
          },
          child: Container(
            color: const Color(0xFFD9D9D9).withOpacity(0.2),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: ListView.separated(
              controller: scrollController,
              itemBuilder: (_, index) {
                if (index == messages.length) {
                  return SizedBox(height: 50.h);
                }

                Message message = messages[index];

                return Align(
                  alignment: message.sender == currentID
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
                            color: message.sender == currentID
                                ? primary
                                : Colors.white,
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
                              message.message,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: message.sender == currentID
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
                              color: message.sender == currentID
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
                  width: 375.w,
                  allowHeightExpand: true,
                  radius: BorderRadius.circular(200.h),
                  controller: textController,
                  borderColor: Colors.transparent,
                  hint: "Message",
                  fillColor: const Color(0xFFEFEFEF),
                  style: context.textTheme.bodyMedium,
                  prefix: GestureDetector(
                    onTap: () {
                      unFocus();
                      animationController.forward();
                    },
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 26.r,
                      color: primary,
                    ),
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      String controllerText = textController.text.trim();
                      if (controllerText.isEmpty) return;
                      messages.add(Message(
                        timestamp: DateTime.now(),
                        message: controllerText,
                        sender: currentID,
                      ));
                      textController.clear();
                      scrollController.animateTo(
                        1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                      setState(() {});
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
              SizedBox(height: 5.h),
              SizeTransition(
                sizeFactor: animation,
                child: EmojiPicker(
                  onBackspacePressed: null,
                  textEditingController: textController,
                  config: Config(
                    height: 250.h,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.20
                              : 1.0),
                    ),
                    swapCategoryAndBottomBar: false,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: const CategoryViewConfig(),
                    bottomActionBarConfig: const BottomActionBarConfig(
                      enabled: false,
                    ),
                    searchViewConfig: const SearchViewConfig(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

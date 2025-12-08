import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/messages.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/bouncing_dot_typing_indicator.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:responsive_ui_kit/responsive_ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({super.key, required this.message});

  final Message message;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool isbackBlur = false;
  final Duration duration = const Duration(milliseconds: 250);
  TextStyle get bubbleTextStyle => TextStyle(
    color:
        widget.message.isUser
            ? Colors.white
            : const Color(0xFF22282B), // Text color contrast
    fontSize: getRespSize(context, size: 16.0),
    fontWeight: FontWeight.w400,
  );

  BorderRadiusGeometry get bubbleBorderRadius => BorderRadius.only(
    topLeft: const Radius.circular(15.0),
    topRight: const Radius.circular(15.0),
    bottomLeft:
        widget.message.isUser
            ? const Radius.circular(15.0)
            : const Radius.circular(
              0.0,
            ), // Rounded on one side, flat on other for visual direction
    bottomRight:
        widget.message.isUser
            ? const Radius.circular(0.0)
            : const Radius.circular(15.0),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          () => setState(() {
            isbackBlur = false;
          }),
      onLongPress:
          () => setState(() {
            isbackBlur = !isbackBlur;
          }),
      child: Align(
        alignment:
            widget.message.isUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          blendMode: BlendMode.srcIn,
          enabled: isbackBlur,
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: bubbleBorderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: AnimatedScale(
                  duration: duration,
                  scale: isbackBlur ? 1.05 : 1,
                  child: Container(
                    // margin: const EdgeInsets.symmetric(
                    //   vertical: 4.0,
                    //   horizontal: 6.0,
                    // ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    ///////////////
                    decoration: BoxDecoration(
                      color:
                          widget.message.isUser
                              ? const Color.fromRGBO(42, 142, 181, 0.7)
                              : const Color(
                                0x25FFFFFF,
                              ), // Different colors for user/bot,
                      border: Border.all(
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 1,
                      ),
                      borderRadius: bubbleBorderRadius,
                    ),
                    child: Builder(
                      builder:
                          (context) =>
                              widget.message.isTyping
                                  ? BouncingDotsTypingIndicator()
                                  : MarkdownBody(
                                    data: widget.message.text,
                                    styleSheet: MarkdownStyleSheet(
                                      p: bubbleTextStyle,
                                      strong: bubbleTextStyle.copyWith(
                                        fontSize: getRespSize(
                                          context,
                                          size: 20,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTapLink: (text, href, title) async {
                                      if (href != null) {
                                        final uri = Uri.parse(href);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        }
                                      }
                                    },
                                  ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

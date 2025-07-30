import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/send_icon.dart';

import 'package:responsive_ui_kit/responsive_ui_kit.dart';

// final typingMessage = Message(text: '', isUser: false, isTyping: true);

// class SendingMessage extends ConsumerStatefulWidget {
//   const SendingMessage({
//     super.key,
//     required this.textController,
//     required this.scrollController,
//   });
//   final TextEditingController textController;
//   final ScrollController scrollController;

//   @override
//   ConsumerState<SendingMessage> createState() => _SendingMessageState();
// }

// class _SendingMessageState extends ConsumerState<SendingMessage> {
//   final FocusNode _textFeildFocusNode = FocusNode();
//   final Duration duration = const Duration(milliseconds: 350);
//   final List<BoxShadow> _unfocusedBoxShadow = const [
//     BoxShadow(
//       offset: Offset(2, 2),
//       spreadRadius: 5,
//       blurRadius: 16,
//       color: Color(0xffffffff),
//     ),
//     BoxShadow(
//       offset: Offset(-2, -2),
//       spreadRadius: 5,
//       blurRadius: 16,
//       color: Color(0xffffffff),
//     ),
//   ];
//   final List<BoxShadow> _focusedBoxShadow = const [
//     BoxShadow(
//       offset: Offset(-2, -2),
//       spreadRadius: 5,
//       blurRadius: 16,
//       color: Color(0xffffffff),
//     ),
//     BoxShadow(
//       offset: Offset(2, 2),
//       spreadRadius: 5,
//       blurRadius: 16,
//       color: Color(0xff969696),
//     ),
//   ];

//   void handleSubmitted(String userText) {
//     // no response to empty message
//     if (userText.isEmpty) return;

//     // adding to the list of message where  it used in listview builder
//     ref
//         .read(messagesProvider.notifier)
//         .add(Message(text: userText, isUser: true));

//     //after adding it  there is a BouncingDotsTypingIndicator  is shown
//     ref.read(messagesProvider.notifier).add(typingMessage);
//     // it gives this prompt to api
//     ref.read(promptProvider.notifier).add(Content.text(userText));

//     // it fetches the response and then is executed in when response is completed
//     ref.read(responseProvider.future).then((value) {
//       // it removes the BouncingDotsTypingIndicator
//       ref.read(messagesProvider.notifier).remove(typingMessage);

//       // and now response is added to user
//       ref
//           .read(messagesProvider.notifier)
//           .add(Message(text: value.text ?? 'no response', isUser: false));
//       //  _scrollToBottom();
//     });

//     widget.textController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 8.0,
//         right: 8.0,
//         bottom: MediaQuery.viewPaddingOf(context).bottom + 14,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 26,
//             child: SendTextField(textController: widget.textController, scrollController: widget.scrollController),
//           ),
//           const Spacer(flex: 1),
//           // Send button
//           Flexible(
//             flex: 3,
//             child: GestureDetector(
//               onTap: () => handleSubmitted(widget.textController.text),
//               child: SendIcon(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AnimatedsendingMessage extends StatefulWidget {
  const AnimatedsendingMessage({
    super.key,
    required this.textController,
    required this.scrollController,
  });
  final TextEditingController textController;
  final ScrollController scrollController;

  @override
  State<AnimatedsendingMessage> createState() => _AnimatedsendingMessageState();
}

class _AnimatedsendingMessageState extends State<AnimatedsendingMessage>
    with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 1000);
  late AnimationController _animationController;
  // late Animation<Alignment> alignAnimation;
  late Animation<double> iconScaleAnimation;
  late Animation<double> textfieldScaleAnimation;
  late Animation<double> textfieldOpacityAnimation;

  // void _scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     widget.scrollController.animateTo(
  //       widget.scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }

  void handleSubmitted(String userText) {
    // context.read<ChatPageBloc>().add(SendMessageEvent(text: userText));
    // no response to empty message
    if (userText.isEmpty) return;

    context.read<ChatPageBloc>().add(SendMessageEvent(text: userText));
    // // no response to empty message
    // if (userText.isEmpty)

    // // adding to the list of message where  it used in listview builder
    // ref
    //     .read(messagesProvider.notifier)
    //     .add(Message(text: userText, isUser: true));

    // //after adding it  there is a BouncingDotsTypingIndicator  is shown
    // ref.read(messagesProvider.notifier).add(typingMessage);
    // // it gives this prompt to api
    // ref.read(promptProvider.notifier).add(Content.text(userText));

    // // it fetches the response and then is executed in when response is completed
    // ref.read(responseProvider.future).then((value) {
    //   // it removes the BouncingDotsTypingIndicator
    //   ref.read(messagesProvider.notifier).remove(typingMessage);

    //   // and now response is added to user
    //   ref
    //       .read(messagesProvider.notifier)
    //       .add(Message(text: value.text ?? 'no response', isUser: false) );
    //   _scrollToBottom();
    // });

    widget.textController.clear();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration)
      ..addListener(() => setState(() {}));

    iconScaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.35, curve: Curves.bounceIn),
      ),
    );
    // ////////////////////
    // alignAnimation =
    //     AlignmentTween(
    //       begin: Alignment.center,
    //       end: Alignment.centerRight,
    //     ).animate(
    //       CurvedAnimation(
    //         parent: _animationController,
    //         curve: Interval(0.3, 0.45),
    //       ),
    //     );
    ////////////////////
    textfieldOpacityAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45, 1, curve: Curves.decelerate),
      ),
    );
    textfieldScaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.35, curve: Curves.decelerate),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 8,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: textfieldOpacityAnimation.value,
              child: SizedBox(
                height: getRespSize(context, size: 55),
                width: context.width * 0.82,
                child: ScaleTransition(
                  scale: textfieldScaleAnimation,
                  child: SendTextField(
                    textController: widget.textController,
                    scrollController: widget.scrollController,
                    onSubmitted: handleSubmitted,
                  ),
                ),
              ),
            ),
          ),

          // Align(
          //   alignment: alignAnimation.value,
          //   child: ScaleTransition(
          //     scale: iconScaleAnimation,
          //     child: GestureDetector(
          //       onTap: () => handleSubmitted(widget.textController.text),
          //       child: SendIcon(),
          //     ),
          //   ),
          // ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Offset icon from center to right
              final double startX =
                  context.width / 2 - 28; // center (icon approx 56px)
              final double endX =
                  context.width * 0.82 + 16; // right aligned with padding
              final double offsetX =
                  lerpDouble(startX, endX, _animationController.value)!;

              return Positioned(
                top: 0,
                bottom: 0,
                left: offsetX,
                child: child!,
              );
            },
            child: ScaleTransition(
              scale: iconScaleAnimation,
              child: GestureDetector(
                onTap: () => handleSubmitted(widget.textController.text),
                child: SendIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SendTextField extends StatefulWidget {
  const SendTextField({
    super.key,
    required this.textController,
    required this.scrollController,
    this.onSubmitted,
  });
  final TextEditingController textController;
  final ScrollController scrollController;
  final void Function(String)? onSubmitted;

  @override
  State<SendTextField> createState() => _SendTextFieldState();
}

class _SendTextFieldState extends State<SendTextField> {
  final FocusNode _textFeildFocusNode = FocusNode();
  final Duration duration = const Duration(milliseconds: 350);
  final List<BoxShadow> _unfocusedBoxShadow = const [
    BoxShadow(
      offset: Offset(2, 2),
      spreadRadius: 5,
      blurRadius: 16,
      color: Color(0xffffffff),
    ),
    BoxShadow(
      offset: Offset(-2, -2),
      spreadRadius: 5,
      blurRadius: 16,
      color: Color(0xffffffff),
    ),
  ];
  final List<BoxShadow> _focusedBoxShadow = const [
    BoxShadow(
      offset: Offset(-2, -2),
      spreadRadius: 5,
      blurRadius: 16,
      color: Color(0xffffffff),
    ),
    BoxShadow(
      offset: Offset(2, 2),
      spreadRadius: 5,
      blurRadius: 16,
      color: Color(0xff969696),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: duration,
      scale: _textFeildFocusNode.hasPrimaryFocus ? 1.04 : 1,
      child: AnimatedContainer(
        duration: duration,
        padding: EdgeInsets.all(getRespSize(context, size: 12)),
        decoration: BoxDecoration(
          color:
              _textFeildFocusNode.hasPrimaryFocus
                  ? Colors.white
                  : const Color.fromRGBO(204, 204, 204, 1),

          borderRadius: BorderRadius.circular(
            getRespSize(context, size: 12.0),
          ), // Rounded corners for the input area
          boxShadow:
              _textFeildFocusNode.hasPrimaryFocus ? _focusedBoxShadow : null,
        ),

        //Inner Container
        child: Container(
          decoration: BoxDecoration(
            boxShadow:
                _textFeildFocusNode.hasPrimaryFocus
                    ? null
                    : _unfocusedBoxShadow,
          ),
          child: Center(
            child: TextField(
              controller: widget.textController,
              focusNode: _textFeildFocusNode,
              keyboardType: TextInputType.text,
              onSubmitted: widget.onSubmitted,
              onTapOutside: (event) {
                _textFeildFocusNode.unfocus();
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
      ),
    );
  }
}

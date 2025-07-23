import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/message_bubble.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatPageBloc, ChatPageState>(
      builder: (context, state) {
        final messages = state.messages;
        if (state is ChatSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(overscroll: false, physics: BouncingScrollPhysics()),
          child: ListView.separated(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatMessageBubble(message: messages[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        );
      },
    );
  }
}

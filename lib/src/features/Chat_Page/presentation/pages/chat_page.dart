import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/custom_painter/cas_logo.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/messages_list.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/sending_message.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffbed9e5), Color(0xfff7f7f9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          title: Text(
            'CAS Virtual Advisor',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              fontSize: getRespSize(context, size: 22),
            ),
          ),
          backgroundColor: Colors.transparent, // App bar color
          elevation: 0, // No shadow for a flatter look
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: context.height * 0.3,
              left:
                  context.width < BreakPoints().maxMobileWidth
                      ? context.width * 0.15
                      : context.width * 0.3,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500, maxHeight: 360),
                child: Hero(
                  tag: 'CASLOGO',
                  child: CustomPaint(
                    size: Size(context.width * 0.7, context.height * 0.22),
                    painter: CasLogoPainter(
                      // maskFilter: MaskFilter.blur(BlurStyle.normal, 3),
                    ),
                  ),
                ),
              ),
            ),
            ChatDataPage(),
          ],
        ),
      ),
    );
  }
}

class ChatDataPage extends StatefulWidget {
  const ChatDataPage({super.key});

  @override
  State<ChatDataPage> createState() => _ChatDataPageState();
}

class _ChatDataPageState extends State<ChatDataPage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: MessagesList(scrollController: scrollController)),
        AnimatedsendingMessage(
          textController: textController,
          scrollController: scrollController,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/bouncing_dot_typing_indicator.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class SendIcon extends StatelessWidget {
  const SendIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [LogoColors.first, LogoColors.sec, LogoColors.third],
          tileMode: TileMode.clamp,
          stops: [0.2, 0.55, 1],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,

      child: Icon(
        Icons.send_rounded,
        size: getRespSize(context, size: 42.0),
        color: Colors.white,
      ),
    );
  }
}

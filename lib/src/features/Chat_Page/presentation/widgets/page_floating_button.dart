import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/custom_painter/cas_logo.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/widgets/transprancy_container.dart';

import 'package:responsive_ui_kit/responsive_ui_kit.dart';

class AiPageFloatingButton extends StatelessWidget {
  const AiPageFloatingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: TransprancyContainer(
        border: Border.all(
          color: Colors.white,
          strokeAlign: BorderSide.strokeAlignInside,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(14, 151, 197, 0.9), // Primary
            Color.fromRGBO(57, 178, 215, 0.9), // Lighter blend
            Color.fromRGBO(130, 217, 232, 0.9), // Aqua
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Row(
          spacing: 4,
          children: [
            Hero(
              tag: 'CASLOGO',
              child: FittedBox(
                child: CustomPaint(
                  size: Size(
                    getRespSize(context, size: 28),
                    getRespSize(context, size: 24),
                  ),
                  painter: CasLogoPainter(blendMode: BlendMode.darken),
                ),
              ),
            ),

            FittedBox(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: getRespSize(context, size: TextSizes.titleSmall),
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color on the glassy surface
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

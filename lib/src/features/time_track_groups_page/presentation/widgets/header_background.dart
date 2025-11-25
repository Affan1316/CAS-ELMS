import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/time_track_groups_page/presentation/widgets/custom_paint.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';


class HeaderBackground extends StatelessWidget {
  const HeaderBackground({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    final w = context.width;

    return ClipPath(
      clipper: HeaderClipper(),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 10, // positive = popped out, negative = pressed in
          intensity: 0.8, // strength of light/dark
          surfaceIntensity: 0.6,
          lightSource: LightSource.topLeft,
          color: AppColors.primaryColor, // from your theme
          boxShape: NeumorphicBoxShape.rect(),
        ),
        child: SizedBox(
          height: height,
          width: w,
        ),
      ),
    );
  }
}

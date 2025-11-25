import 'dart:ui';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

import '../../../../core/theme/app_colors.dart';

class LiftedCarousel extends StatefulWidget {
  const LiftedCarousel({
    super.key,
    required this.items,
    this.viewportFraction = 1 / 3,
    this.lift = 40,
    this.drop = 24,
    this.minScale = 0.92,
    this.elevation = 10,
    this.padEnds = true,
    this.onPageChanged,
  });

  /// Widgets to show (cards, images, etc.)
  final List<Widget> items;

  /// Width of each page relative to the viewport. `1/3` shows exactly 3.
  final double viewportFraction;

  /// How much the side items move UP (in pixels).
  final double lift;

  /// How much the center item moves DOWN (in pixels).
  final double drop;

  /// Minimum scale for neighbors. `1.0` = no scaling.
  final double minScale;

  /// Base elevation for the center card (neighbors get less).
  final double elevation;

  /// Whether to pad the ends so the first/last item can sit centered.
  final bool padEnds;

  final ValueChanged<int>? onPageChanged;

  @override
  State<LiftedCarousel> createState() => _LiftedCarouselState();
}

class _LiftedCarouselState extends State<LiftedCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _pageValue() {
    if (!_controller.hasClients) return _controller.initialPage.toDouble();
    final pv = _controller.page ?? _controller.initialPage.toDouble();
    return pv;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      padEnds: widget.padEnds,
      itemCount: widget.items.length,
      onPageChanged: widget.onPageChanged,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final page = _pageValue();
            final d = (page - index).abs(); // 0 for center, ~1 for neighbors
            final t = d.clamp(0.0, 1.0);

            // Vertical offset: center goes DOWN by `drop`, neighbors go UP by `lift`.
            final double y = lerpDouble(widget.drop, -widget.lift, t)!;

            // Subtle scale: center 1.0, neighbors minScale.
            final double scale = lerpDouble(1.0, widget.minScale, t)!;

            // Elevation fades with distance (center highest).
            final double elev = lerpDouble(widget.elevation, 1.0, t)!;

            // Opacity (optional): keep fully visible, but you can dim distant items if you want.
            final double opacity = lerpDouble(1.0, 0.95, t)!;

            return Center(
              child: Transform.translate(
                offset: Offset(0, y),
                child: Transform.scale(
                  scale: scale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    // Material for elevation and shadow
                    child: Opacity(
                      opacity: opacity,
                      child: Material(
                        elevation: elev,
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: widget.items[index],
        );
      },
    );
  }
}

/// --- Demo card content below (replace with your own widgets) ---

class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    this.child,
    this.imgPath,
    required this.courseName,
    this.size = 48,
    this.onPressed,
    required this.index,
    this.selectedIndex,
  });
  final double size;
  final Widget? child;
  final String? imgPath;
  final String courseName;
  final VoidCallback? onPressed;
  final int? selectedIndex;
  final int index;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isSelected = false;

  @override
  void didUpdateWidget(covariant CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        if (widget.selectedIndex != null) {
          isSelected = widget.index == widget.selectedIndex;
        } else {
          isSelected = false;
        }
        // isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 190,
        maxHeight: 190,
        minWidth: 160,
      ),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Neumorphic(
          style: NeumorphicStyle(
            color: AppColors.background,
            depth: isSelected ? -6 : 6,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 12),
                widget.child ??
                    SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: Image.asset(widget.imgPath!, fit: BoxFit.cover),
                    ),
                SizedBox(height: 22),
                Text(
                  widget.courseName,
                  style: TextStyle(
                    fontSize: TextSizes.titleMedium,
                    // fontWeight: FontWeight.bold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

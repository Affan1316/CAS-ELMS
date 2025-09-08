import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicHeader extends SliverPersistentHeaderDelegate {
  final String title;

  NeumorphicHeader({required this.title});
  double? topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    topPadding = MediaQuery.viewPaddingOf(context).top;
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        color: const Color(0xff0097b2),
        boxShape: const NeumorphicBoxShape.rect(),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          height: maxExtent,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 110;

  @override
  double get minExtent => topPadding ?? 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

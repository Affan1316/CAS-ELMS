import 'package:flutter/material.dart';

class CasLogoPainter extends CustomPainter {
  CasLogoPainter({
    this.heightdeivation = 0,
    this.cSide = 0,
    this.aSides = 0,
    this.sSides = 0,
    this.blendMode = BlendMode.darken,
    this.maskFilter,
  });

  double heightdeivation;
  BlendMode blendMode;
  MaskFilter? maskFilter;
  double aSides;
  double cSide;
  double sSides;
  @override
  void paint(Canvas canvas, Size size) {
    var Size(height: h, width: w) = size;

    // paths
    Path cHeightPath = Path();
    //topLeft
    cHeightPath.moveTo(w * 0.1089, h * (0.05 + (0.8875 * heightdeivation)));
    //bottomLeft
    cHeightPath.lineTo(w * 0.0, h * 0.9375);
    //bottomRight
    cHeightPath.lineTo(w * 0.14535, h * 0.9375);
    //topRight
    cHeightPath.lineTo(w * 0.25425, h * (0.1125 + (0.825 * heightdeivation)));
    cHeightPath.close();

    Path aHeightPath = Path();
    //bottomLeft
    aHeightPath.moveTo(w * 0.25425, h * 0.9375 + (0.875));
    //bottomRight
    aHeightPath.lineTo(w * 0.409113, h * 0.9375);
    //topRight
    aHeightPath.lineTo(w * 0.59085, h * (0.0625 + (0.875 * heightdeivation)));
    //topLeft
    aHeightPath.lineTo(w * 0.43605, h * (0.0625 + (0.875 * heightdeivation)));
    aHeightPath.close();

    Path sHeightPath = Path();
    //bottomLeft
    sHeightPath.moveTo(w * 0.59085, h * 0.9375);
    //bottomRight
    sHeightPath.lineTo(w * 0.7452, h * 0.9375);
    //topRight
    sHeightPath.lineTo(w * 0.86355, h * (0.0625 + (0.875 * heightdeivation)));
    //topLeft
    sHeightPath.lineTo(w * 0.7272, h * (0.0625 + (0.875 * heightdeivation)));
    sHeightPath.close();

    Path cTopSidePath = Path();
    //topRight
    cTopSidePath.moveTo(w * 0.25425, h * 0.1125);
    //topLeft
    cTopSidePath.lineTo(
      w * (0.4096 - (0.15535 * cSide)),
      h * (0.1875 - (0.075 * cSide)),
    );
    //bottomRight
    cTopSidePath.lineTo(
      w * (0.3698 - (0.14255 * cSide)),
      h * (0.375 - (0.125 * cSide)),
    );
    //bottomLeft
    cTopSidePath.lineTo(w * 0.22725, h * 0.25);
    cTopSidePath.close();

    Path cBottomSidepath = Path();
    //bottomLeft
    cBottomSidepath.moveTo(w * 0.13635, h * 0.91);
    //BottomRight
    cBottomSidepath.lineTo(w * (0.31815 - (0.1818 * cSide)), h * 0.91);
    //topLeft
    cBottomSidepath.lineTo(
      w * (0.3636 - (0.22725 * cSide)),
      h * (0.64 + (0.086 * cSide)),
    );
    //topRight
    cBottomSidepath.lineTo(w * 0.13635, h * 0.726);
    cBottomSidepath.close();

    Path aSidePath = Path();
    //topRight
    aSidePath.moveTo(w * 0.59085, h * 0.0625);
    //bottomRight
    aSidePath.lineTo(
      w * (0.768 - (0.17715 * aSides)),
      h * (0.934 - (0.8715 * aSides)),
    );
    //bottomLeft
    aSidePath.lineTo(
      w * (0.6363 - (0.1363 * aSides)),
      h * (0.934 - (0.6215 * aSides)),
    );
    //topLeft
    aSidePath.lineTo(w * 0.5, h * 0.3125);
    aSidePath.close();

    Path sBottomSidePath = Path();
    //bottomLeft
    sBottomSidePath.moveTo(w * 0.59085, h * 0.9375);
    //topLeft
    sBottomSidePath.lineTo(
      w * (0.4545 + (0.13635 * sSides)),
      h * (0.5625 + (0.375 * sSides)),
    );
    //topRight
    sBottomSidePath.lineTo(
      w * (0.59085 + (0.15435 * sSides)),
      h * (0.5 + (0.4375 * sSides)),
    );
    //bottomRight
    sBottomSidePath.lineTo(w * 0.7452, h * 0.9375);
    sBottomSidePath.close();

    Path sTopSidePath = Path();
    //topRight
    sTopSidePath.moveTo(w * 0.86355, h * 0.0625);
    //bottomRight
    sTopSidePath.lineTo(
      w * (1 - (0.13645 * sSides)),
      h * (0.3125 - (0.25 * sSides)),
    );
    //bottomLeft
    sTopSidePath.lineTo(
      w * (0.909 - (0.0909 * sSides)),
      h * (0.4375 - (0.1875 * sSides)),
    );
    //topLeft
    sTopSidePath.lineTo(w * 0.8181, h * 0.25);
    sTopSidePath.close();

    //paint areas
    Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = maskFilter
      ..color = Color.fromARGB(255, 90, 69, 89);

    Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = maskFilter
      ..color = Color.fromARGB(255, 14, 150, 200);

    Paint paint3 = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = maskFilter
      ..color = Color.fromARGB(255, 90, 69, 89);
    Paint paint4 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = blendMode
      ..maskFilter = maskFilter
      ..color = Color.fromARGB(255, 66, 49, 67);

    Paint paint5 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = blendMode
      ..maskFilter = maskFilter
      ..color = Color.fromARGB(255, 0, 109, 150);


      

    // draw paths
    canvas.drawPath(cTopSidePath, paint4);
    canvas.drawPath(cBottomSidepath, paint4);
    canvas.drawPath(aSidePath, paint5);
    canvas.drawPath(sBottomSidePath, paint4);
    canvas.drawPath(sTopSidePath, paint4);
    canvas.drawPath(cHeightPath, paint1);
    canvas.drawPath(aHeightPath, paint2);
    canvas.drawPath(sHeightPath, paint3);
  }

  @override
  bool shouldRepaint(CasLogoPainter oldDelegate) =>
      oldDelegate.heightdeivation != heightdeivation ||
      oldDelegate.aSides != aSides ||
      oldDelegate.cSide != cSide ||
      oldDelegate.sSides != sSides;

  @override
  bool shouldRebuildSemantics(CasLogoPainter oldDelegate) =>
      oldDelegate.heightdeivation != heightdeivation ||
      oldDelegate.aSides != aSides ||
      oldDelegate.cSide != cSide ||
      oldDelegate.sSides != sSides;
}

class CaslogoWidget extends StatelessWidget {
  const CaslogoWidget({
    super.key,
    required this.size,
    required this.heightdeivation,
    required this.cSides,
    required this.aSides,
    required this.sSides,
  });
  final Size size;
  final double heightdeivation;
  final double cSides;
  final double aSides;
  final double sSides;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: CasLogoPainter(
        heightdeivation: heightdeivation,
        cSide: cSides,
        aSides: aSides,
        sSides: sSides,
      ),
    );
  }
}

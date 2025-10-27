
// Responsive utility class
import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double sp(BuildContext context, double size) {
    return size * MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
  }

  static double wp(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage / 100;
  }

  static double hp(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage / 100;
  }
}
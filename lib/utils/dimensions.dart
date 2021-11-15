import 'package:flutter/material.dart';

class Dimentions {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getPercentWidth(BuildContext context, double percent) {
    var width = getWidth(context);
    return (percent / 100) * width;
  }

  static double getPercentHeight(BuildContext context, double percent) {
    var height = getHeight(context);
    return (percent / 100) * height;
  }
}

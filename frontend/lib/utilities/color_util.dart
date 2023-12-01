

import 'package:flutter/material.dart';

class ColorUtil {
  ColorUtil._();

  static addColor(Color left, Color right, double rate) {
    double other = 1 - rate;

    int a = (left.alpha * rate + right.alpha * other).toInt();
    int r = (left.red * rate + right.red * other).toInt();
    int g = (left.green * rate + right.green * other).toInt();
    int b = (left.blue  * rate + right.blue * other).toInt();

    return Color.fromARGB(a, r, g, b);
  }
}
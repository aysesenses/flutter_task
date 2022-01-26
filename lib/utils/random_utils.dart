import 'dart:math';
import 'package:flutter/material.dart';

class Util {
  static List targetRandom() {
    List targetList = <int>[];
    int indexx = Random().nextInt(5);
    while (targetList.length < 3) {
      if (!targetList.contains(indexx)) {
        targetList.add(indexx);
      } else {
        indexx = Random().nextInt(5);
      }
    }
    return targetList;
  }

  static Color randomColor() =>
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  static int randomListIndex() => Random().nextInt(5);

  static var numberList = List.generate(6, (index) => Random().nextInt(10));

  static List<Color> colorList = List.generate(6,
      (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);
  static List<Color> changeColorList() => List.generate(6,
      (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);
}

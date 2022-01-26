import 'package:flutter/material.dart';

class Constant {
  static String appName = "Numbers";
  static Color backgroundColor = Colors.indigo.shade100;
  static Color targetBackgroundColor = Colors.indigo.shade300;
  static Color scoreBackgroundColor = Colors.indigo.shade400;

  static const TextStyle numButtonTextStyle =
      TextStyle(fontSize: 48, color: Colors.white);
  static const TextStyle timerTextStyle =
      TextStyle(color: Colors.white, fontSize: 20);
  static const TextStyle scoreTextStyle =
      TextStyle(color: Colors.white, fontSize: 20);
  static const TextStyle targetTextStyle =
      TextStyle(color: Colors.white, fontSize: 16);
  static const TextStyle targetNumberTextStyle =
      TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white);
  static  TextStyle getReadyTextStyle =
      TextStyle(fontSize: 24, color: Colors.grey.shade600, fontWeight: FontWeight.bold);
  static const TextStyle appNameTextStyle = TextStyle(fontSize: 36);
}

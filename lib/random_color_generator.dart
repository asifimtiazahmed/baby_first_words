import 'dart:math';
import 'package:flutter/material.dart';
import 'package:baby_f_words/app_theme.dart';

class UniqueColorGenerator {
  static Random random = Random();
  static Color getColor() {
    return AppColors.cardColors[random.nextInt(AppColors.cardColors.length)];
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Vibrant, kid-friendly palette
  static const Color sunnyYellow = Color(0xFFFFD54F);
  static const Color skyBlue = Color(0xFF4FC3F7);
  static const Color grassGreen = Color(0xFFAED581);
  static const Color candyPink = Color(0xFFF06292);
  static const Color softPurple = Color(0xFFBA68C8);
  static const Color creamyWhite = Color(0xFFFFF9C4);
  static const Color darkText = Color(0xFF424242);
  
  static const List<Color> cardColors = [
    sunnyYellow,
    skyBlue,
    grassGreen,
    candyPink,
    softPurple,
  ];
}

class AppTextStyles {
  // Fun, spicy header font
  static TextStyle get header => GoogleFonts.spicyRice(
    fontSize: 24,
    color: AppColors.darkText,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get display => GoogleFonts.spicyRice(
    fontSize: 48,
    color: AppColors.darkText,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(2.0, 2.0),
      ),
    ],
  );
  
  static TextStyle get buttonText => GoogleFonts.nunito(
    fontSize: 20,
    color: AppColors.darkText,
    fontWeight: FontWeight.bold,
  );
}

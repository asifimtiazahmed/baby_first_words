import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kGoogleStyle = TextStyle(letterSpacing: 1.2, fontSize: 32, color: Colors.redAccent);

const kBasicTextStyle = TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold);

TextStyle spicyRice = GoogleFonts.spicyRice(
  textStyle: const TextStyle(
      color: Colors.redAccent, fontSize: 50, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
);

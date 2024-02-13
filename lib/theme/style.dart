import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Colors.white;
const Color secondaryColor = Color(0xFF1FA0C9);
const Color onPrimaryColor = Colors.black;
const Color labelColor = Color(0xFFB9B9B9);
const Color hintColor = Color(0xFF757575);
const Color resultColor = Color(0xFF107C41);

ThemeData lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
      ),
  textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
      onPrimary: primaryColor,
      textStyle: myTextTheme.bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

final TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.inter(
      fontSize: 109, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.inter(
      fontSize: 68, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.inter(fontSize: 55, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.inter(
      fontSize: 39, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.inter(fontSize: 27, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.inter(
      fontSize: 21, fontWeight: FontWeight.w600, letterSpacing: 0.15),
  titleMedium: GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.robotoCondensed(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.robotoCondensed(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.robotoCondensed(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.robotoCondensed(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.robotoCondensed(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0x00356859);
const Color secondaryColor = Color(0x00fd5523);

const Color primaryColor500 = Color(0x0037966f);
const Color primaryColor100 = Color(0x00b9e4c9);

const Color secondaryColor50 = Color(0x00fffbe6);

final TextTheme restaurantTextTheme = TextTheme(
  displayLarge: GoogleFonts.montserrat(
      fontSize: 98,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5
  ),
  displayMedium: GoogleFonts.montserrat(
      fontSize: 61,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5
  ),
  displaySmall: GoogleFonts.montserrat(
      fontSize: 49,
      fontWeight: FontWeight.w400
  ),
  headlineMedium: GoogleFonts.montserrat(
      fontSize: 35,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25
  ),
  headlineSmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w400
  ),
  titleLarge: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15
  ),
  titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15
  ),
  titleSmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1
  ),
  bodyLarge: GoogleFonts.lekton(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
  ),
  bodyMedium: GoogleFonts.lekton(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25
  ),
  labelLarge: GoogleFonts.lekton(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25
  ),
  bodySmall: GoogleFonts.lekton(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4
  ),
  labelSmall: GoogleFonts.lekton(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5
  ),
);

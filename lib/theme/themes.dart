import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: AppColors.neutralGrayLight,
  useMaterial3: true,
);

final darkTheme = lightTheme;

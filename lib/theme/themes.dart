import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7E4D41)),
  textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: AppColors.neutralGrayLight,
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,
  //
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.accentBrown,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900).copyWith(color: Colors.white),
    centerTitle: false,
    // toolbarHeight: 100,
  ),
  //
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: IconThemeData(size: 55, color: AppColors.accentBrown),
    unselectedIconTheme: IconThemeData(size: 46, color: AppColors.neutralGrayMedium),
  ),
  //
);

final darkTheme = lightTheme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_project/app_colors.dart';

class MyThemeData {

  static final ThemeData lightTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        showSelectedLabels: false,
      ),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.primaryColor, width: 2))),
      textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor)));
  static final ThemeData darkTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundDarkColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        showSelectedLabels: false,
      ),
      textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.blackDarkColor)));
}

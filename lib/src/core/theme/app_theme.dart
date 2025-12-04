import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldLightThemeBackground,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.containerColor),
    textTheme: Typography.material2021().black,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldDarkThemeBackground,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.containerColor),
    textTheme: Typography.material2021().white,
    useMaterial3: true,
  );
}

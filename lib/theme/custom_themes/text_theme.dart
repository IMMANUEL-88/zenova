import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenova/constants/colors.dart';

class ETextTheme {
  ETextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: 32.0.sp,
      fontWeight: FontWeight.bold,
      color: EColors.black,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24.0.sp,
      fontWeight: FontWeight.w600,
      color: EColors.black,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18.0.sp,
      fontWeight: FontWeight.w600,
      color: EColors.black,
    ),
    titleLarge: TextStyle().copyWith(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w600,
      color: EColors.black,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w500,
      color: EColors.black,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w400,
      color: EColors.black,
    ),
    bodyLarge: TextStyle().copyWith(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w500,
      color: EColors.black,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.normal,
      color: EColors.black,
    ),
    bodySmall: TextStyle().copyWith(
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w500,
        color: EColors.black.withValues(alpha: 0.5)),
    labelLarge: TextStyle().copyWith(
      fontSize: 12.0.sp,
      fontWeight: FontWeight.normal,
      color: EColors.black,
    ),
    labelMedium: TextStyle().copyWith(
        fontSize: 12.0.sp,
        fontWeight: FontWeight.normal,
        color: EColors.black.withValues(alpha: 0.5)),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
        fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: EColors.white),
    headlineMedium: TextStyle().copyWith(
        fontSize: 24.0.sp, fontWeight: FontWeight.w600, color: EColors.white),
    headlineSmall: TextStyle().copyWith(
        fontSize: 18.0.sp, fontWeight: FontWeight.w600, color: EColors.white),
    titleLarge: TextStyle().copyWith(
        fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: EColors.white),
    titleMedium: TextStyle().copyWith(
        fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: EColors.white),
    titleSmall: TextStyle().copyWith(
        fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: EColors.white),
    bodyLarge: TextStyle().copyWith(
        fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: EColors.white),
    bodyMedium: TextStyle().copyWith(
        fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: EColors.white),
    bodySmall: TextStyle().copyWith(
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w500,
        color: EColors.white.withValues(alpha: 0.5)),
    labelLarge: TextStyle().copyWith(
        fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: EColors.white),
    labelMedium: TextStyle().copyWith(
        fontSize: 12.0.sp,
        fontWeight: FontWeight.normal,
        color: EColors.white.withValues(alpha: 0.5)),
  );
}

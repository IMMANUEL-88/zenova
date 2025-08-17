import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

/* -- Light & Dark Outlined Button Themes -- */
class EOutlinedButtonTheme {
  EOutlinedButtonTheme._(); //To avoid creating instances

/* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Color(0xfff7f7f7),
      side: const BorderSide(color: EColors.primaryColor),
      textStyle:  TextStyle(
          fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w600),
      padding:  EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
    ),
  ); // OutlinedButtonThemeData

/* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Color(0xfff7f7f7),
      side: const BorderSide(color: EColors.primaryColor),
      textStyle:  TextStyle(
          fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w600),
      padding:  EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
    ),
  ); // OutlinedButtonThemeData
}

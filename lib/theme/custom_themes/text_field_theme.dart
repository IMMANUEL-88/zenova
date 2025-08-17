import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class ETextFormFieldTheme {
  ETextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.black,
    suffixIconColor: EColors.darkGrey,
// constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: ESizes.fontSizeMd.sp,
        color: Colors.grey,
        fontWeight: FontWeight.bold),
    hintStyle: const TextStyle()
        .copyWith(fontSize: ESizes.fontSizeSm.sp, color: EColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle:
        const TextStyle().copyWith(color: EColors.black.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.w, color: EColors.grey),
    ),

    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:
          BorderSide(width: 1.w, color: Colors.black.withValues(alpha: 0.6)),
    ),

    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.5.w, color: EColors.dark),
    ),

    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.w, color: EColors.warning),
    ),

    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 2.w, color: EColors.warning),
    ),
  ); // InputDecorationTheme

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: EColors.darkGrey,
    suffixIconColor: EColors.darkGrey,
// constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle()
        .copyWith(fontSize: ESizes.fontSizeMd.sp, color: EColors.white),
    hintStyle: const TextStyle()
        .copyWith(fontSize: ESizes.fontSizeSm.sp, color: EColors.white),
    floatingLabelStyle:
        const TextStyle().copyWith(color: EColors.white.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.w, color: EColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.w, color: EColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.5.w, color: EColors.lightGrey),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 1.w, color: EColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
      borderSide:  BorderSide(width: 2.w, color: EColors.warning),
    ),
  );
}

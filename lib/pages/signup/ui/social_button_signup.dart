import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenova/helper/helper_functions.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';

class ESocialButtonsSignUp extends StatelessWidget {
  final Function() onGooglePressed;
  final Function() onFacebookPressed;

  const ESocialButtonsSignUp({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  dark ? EColors.darkGrey : EColors.dark.withValues(alpha: 0.6),
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: IconButton(
            onPressed: onGooglePressed,
            icon: Image(
              width: ESizes.iconMd.w,
              height: ESizes.iconMd.h,
              image: AssetImage(EImages.google),
            ),
          ),
        ),
        SizedBox(
          width: ESizes.spaceBtwItems.w,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  dark ? EColors.darkGrey : EColors.dark.withValues(alpha: 0.6),
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: IconButton(
            onPressed: onFacebookPressed,
            icon: Image(
              width: ESizes.iconMd.w,
              height: ESizes.iconMd.h,
              image: AssetImage(EImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}

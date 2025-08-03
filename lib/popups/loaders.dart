import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenova/helper/helper_functions.dart';


class EAnimationLoaderWidget extends StatelessWidget {
  final String text;
  final String image;

  const EAnimationLoaderWidget({
    super.key,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 80.h,
            width: 80.w,
            fit: BoxFit.contain,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: dark ? Colors.white : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}

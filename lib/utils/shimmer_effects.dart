
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zenova/constants/colors.dart';

class EShimmerEffect extends StatelessWidget {
   const EShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  });

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:  Colors.grey[300]!,
      highlightColor:  Colors.grey[100]!,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: color ?? EColors.white,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}

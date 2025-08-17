import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EFormDivider extends StatelessWidget {
  const EFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: Colors.black.withValues(alpha: 0.5),
            thickness: 1,
            indent: 50,    
            endIndent: 5,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        Text(
          dividerText,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: Colors.black.withValues(alpha: 0.5)),
        ),
        SizedBox(
          width: 2.w,
        ),
        Flexible(
          child: Divider(
            color: Colors.black.withValues(alpha: 0.5),
            thickness: 1,
            indent: 5,
            endIndent: 50,
          ),
        )
      ],
    );
  }
}

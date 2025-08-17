import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/utils/appbar.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    final userName = HiveStorageHelper.getUserName();
    final userEmail = HiveStorageHelper.getUserEmail();

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          ESizes.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                ),
              ],
            ),

            SizedBox(
              height: ESizes.spaceBtwItems,
            ),

            Divider(),

            SizedBox(
              height: ESizes.spaceBtwItems,
            ),

            // Profile Info
            Text(
              "Profile Information:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: dark ? EColors.white : Colors.black,
              ),
            ),

            SizedBox(
              height: ESizes.spaceBtwInputFields,
            ),

            /// Name & Email
            // Name
            Row(
              children: [
                Text(
                  "Name:",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: dark ? EColors.darkGrey : Colors.black26,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  userName ?? "User Name",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: dark ? EColors.white : Colors.black,
                  ),
                )
              ],
            ),

            SizedBox(
              height: ESizes.sm,
            ),

            // Email
            Row(
              children: [
                Text(
                  "Email:",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: dark ? EColors.darkGrey : Colors.black26,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  userEmail ?? "User Email",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: dark ? EColors.white : Colors.black,
                  ),
                )
              ],
            ),

            SizedBox(
              height: ESizes.spaceBtwItems,
            ),

            Divider()
          ],
        ),
      ),
    );
  }
}

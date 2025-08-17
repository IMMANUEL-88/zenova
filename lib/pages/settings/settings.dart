import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/provider/theme_provider.dart';
import 'package:zenova/utils/appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consume the provider to get the current state and the method to change it.
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Determine the switch's current state.
    // If themeMode is 'system', check the device's actual brightness.
    final bool isCurrentlyDark;
    if (themeProvider.themeMode == ThemeMode.system) {
      isCurrentlyDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    } else {
      isCurrentlyDark = themeProvider.themeMode == ThemeMode.dark;
    }

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          ESizes.md,
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isCurrentlyDark
                    ? EColors.primaryColor.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: isCurrentlyDark
                      ? EColors.primaryColor.withOpacity(0.3)
                      : EColors.darkGrey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: ESizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: isCurrentlyDark ? EColors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: isCurrentlyDark,
                      // This call now updates the global state via the provider.
                      onChanged: (value) async{
                        await Future.delayed(const Duration(milliseconds: 100));
                        themeProvider.setTheme(value);
                      },
                      activeColor: EColors.primaryColor,
                      activeTrackColor: EColors.primaryColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),

            // TODO: Add Notification
          ],
        ),
      ),
    );
  }
}

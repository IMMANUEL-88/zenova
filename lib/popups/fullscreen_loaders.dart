import 'package:flutter/material.dart';
import 'package:zenova/constants/image_strings.dart';
import 'loaders.dart';

/// A utility class for managing a full-screen loading dialog.
class EFullScreenLoader {
  static bool isActive = false;

  static void openLoadingDialog(String text, BuildContext context) {
    isActive = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EAnimationLoaderWidget(
                  text: text,
                  image: EImages.lightLoadingAppLogo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading(BuildContext context) {
    if (isActive && Navigator.of(context, rootNavigator: true).canPop()) {
      isActive = false;
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      //print("No loading dialog to close.");
    }
  }
}

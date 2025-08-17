import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/appbar.dart';
import 'dart:convert';

import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class LoginOtpVerificationPage extends StatefulWidget {
  final String email;

  const LoginOtpVerificationPage({super.key, required this.email});

  @override
  State<LoginOtpVerificationPage> createState() =>
      _LoginOtpVerificationPageState();
}

class _LoginOtpVerificationPageState extends State<LoginOtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String message = "";
  bool otpSuccess = false;
  final String? devUrl = dotenv.env['DEV_URL'];
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      Vibration.vibrate(duration: 200);
      setState(() => message = "Please enter a valid 6-digit OTP");
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      final url = Uri.parse('$devUrl/otp/verify-otp');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otpController.text,
        }),
      );

      final body = jsonDecode(response.body);
      final success =
          response.statusCode == 200 && body["message"] == "OTP verified";

      setState(() {
        isLoading = false;
        message = body["message"];
      });

      if (success) {
        EFullScreenLoader.openLoadingDialog("Logging in...", context);
        await HiveStorageHelper.setLoggedIn(true);
        Vibration.vibrate(duration: 100);
        ELoaders.successSnackBar(
          context: context,
          title: "Yay! OTP Verified",
          message: "Welcome back User",
        );
        EFullScreenLoader.stopLoading(context);
        context.go('/home');
      } else {
        Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      Vibration.vibrate(duration: 200);
      setState(() {
        isLoading = false;
        message = "Something went wrong. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            "OTP Verification",
            style: TextTheme.of(context).headlineMedium,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  dark ? EImages.darkEmailVerify : EImages.lightEmailVerify,
                  width: EHelperFunctions.screenWidth(context) * 0.3.w,
                ),
                Text(
                  "Verify your email",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter the 6-digit code sent to your email.",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 24.h),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: widget.email),
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.h),
                PinCodeTextField(
                  appContext: context,
                  controller: otpController,
                  length: 6,
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8.r),
                    fieldHeight: 50.h,
                    fieldWidth: 40.w,
                    activeFillColor: Colors.white,
                    inactiveColor: Colors.grey.shade400,
                    selectedColor: Colors.blue,
                  ),
                  onChanged: (value) {},
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    minimumSize: Size(0.21.sw, 0.05.sh),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: dark ? EColors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  style: TextStyle(
                    color: message == "OTP verified"
                        ? Colors.green
                        : Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/popups/snackbar.dart';
import 'dart:convert';

import 'package:zenova/utils/appbar.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpPage({super.key, required this.email});

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final String? devUrl = dotenv.env['DEV_URL'];

  bool otpVerified = false;
  bool isLoading = false;
  String message = "";

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      setState(() => message = "Enter a valid 6-digit OTP");
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
        body: jsonEncode({"email": widget.email, "otp": otpController.text}),
      );

      final body = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        message = body['message'];
        otpVerified = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Something went wrong. Try again.";
      });
    }
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => message = "Please fill both password fields.");
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => message = "Passwords do not match.");
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      final url = Uri.parse('$devUrl/auth/resetPass');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": widget.email, "newPassword": newPassword}),
      );

      final body = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        message = body["message"];
      });

      if (response.statusCode == 200) {
        ELoaders.successSnackBar(
            context: context,
            title: "Yay! Good Job!",
            message: "Password updated successfully.");
        context.go('/'); // Redirect to login or home
      } else {
        ELoaders.errorSnackBar(
          context: context,
          title: "Oops! Something went wrong",
          message: body["error"] ?? "Failed to update password",
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Server error.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

// Replace with your own method
    void removeSpaces(String value) {
      if (value.contains(' ')) {
        setState(() {
          newPasswordController.text = value.replaceAll(' ', '');
          confirmPasswordController.text = value.replaceAll(' ', '');
        });
      }
    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            "Reset Password",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  dark ? EImages.darkNewPassword : EImages.lightNewPassword,
                  width: EHelperFunctions.screenWidth(context) * 0.3.w,
                ),
                Text(
                  "Verify OTP",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the OTP sent to your email:",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: TextEditingController(text: widget.email),
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 16),
                PinCodeTextField(
                  appContext: context,
                  controller: otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.blue,
                  ),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 20),
                if (!otpVerified)
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
                        ? const CircularProgressIndicator()
                        : Text(
                            "Verify OTP",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: dark ? EColors.white : Colors.black),
                          ),
                  ),
                if (otpVerified) ...[
                  const SizedBox(height: 16),
                  // New Password - hidden
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    cursorColor: EColors.primaryColor,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(
                      color: dark ? EColors.light : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: dark ? EColors.dark : Colors.white,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: dark
                            ? EColors.white.withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.7),
                        size: 26.r,
                      ),
                      labelText: "New Password",
                      labelStyle: TextStyle(
                          color: dark
                              ? EColors.white.withValues(alpha: 0.7)
                              : Colors.grey,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                          color: EColors.primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      hintText: '',
                      hintStyle:
                          TextStyle(color: dark ? EColors.white : Colors.black),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0.h, horizontal: 16.0.w),
                      enabledBorder: OutlineInputBorder().copyWith(
                        borderRadius:
                            BorderRadius.circular(ESizes.inputFieldRadius.r),
                        borderSide: BorderSide(
                            width: 1.w,
                            color:
                                dark ? EColors.darkerGrey : EColors.darkGrey),
                      ),
                      focusedBorder: OutlineInputBorder().copyWith(
                        borderRadius:
                            BorderRadius.circular(ESizes.inputFieldRadius.r),
                        borderSide: BorderSide(
                            width: 1.5.w,
                            color:
                                dark ? EColors.darkGrey : EColors.darkerGrey),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                    },
                    onChanged: removeSpaces,
                  ),

                  SizedBox(height: 16.h),

// Confirm Password - readable
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: false, // Not hidden
                    cursorColor: EColors.primaryColor,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(
                      color: dark ? EColors.light : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: dark ? EColors.dark : Colors.white,
                      prefixIcon: Icon(
                        Icons.lock_open_outlined,
                        color: dark
                            ? EColors.white.withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.7),
                        size: 26.r,
                      ),
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(
                          color: dark
                              ? EColors.white.withValues(alpha: 0.7)
                              : Colors.grey,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                          color: EColors.primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                      hintText: '',
                      hintStyle:
                          TextStyle(color: dark ? EColors.white : Colors.black),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0.h, horizontal: 16.0.w),
                      enabledBorder: OutlineInputBorder().copyWith(
                        borderRadius:
                            BorderRadius.circular(ESizes.inputFieldRadius.r),
                        borderSide: BorderSide(
                            width: 1.w,
                            color:
                                dark ? EColors.darkerGrey : EColors.darkGrey),
                      ),
                      focusedBorder: OutlineInputBorder().copyWith(
                        borderRadius:
                            BorderRadius.circular(ESizes.inputFieldRadius.r),
                        borderSide: BorderSide(
                            width: 1.5.w,
                            color:
                                dark ? EColors.darkGrey : EColors.darkerGrey),
                      ),
                    ),
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    onChanged: removeSpaces,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : resetPassword,
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
                        ? const CircularProgressIndicator()
                        : Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: dark ? EColors.white : Colors.black,
                            ),
                          ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: message == "OTP verified" || message == "Password updated successfully."
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

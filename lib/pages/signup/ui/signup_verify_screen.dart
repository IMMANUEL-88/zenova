import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/appbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignupOtpPage extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignupOtpPage({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<SignupOtpPage> createState() => _SignupOtpPageState();
}

class _SignupOtpPageState extends State<SignupOtpPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String message = "";
  final String? devUrl = dotenv.env['DEV_URL'];

  Future<void> verifyOtpAndSignup() async {
    if (otpController.text.length != 6) {
      setState(() => message = "Please enter a valid 6-digit OTP");
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      final verifyRes = await http.post(
        Uri.parse('$devUrl/otp/verify-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otpController.text,
        }),
      );

      final verifyBody = jsonDecode(verifyRes.body);
      final success = verifyRes.statusCode == 200 &&
          verifyBody["message"] == "OTP verified";

      if (success) {
        final signupRes = await http.post(
          Uri.parse('$devUrl/auth/signup'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "firstName": widget.firstName,
            "lastName": widget.lastName,
            "email": widget.email,
            "password": widget.password,
          }),
        );

        final signupBody = jsonDecode(signupRes.body);
        if (signupRes.statusCode == 201 &&
            signupBody['message'] == 'User registered successfully') {
          ELoaders.successSnackBar(
            context: context,
            title: "Signup Complete",
            message: "Welcome ${widget.firstName}!",
          );
          context.go('/');
        } else {
          ELoaders.errorSnackBar(
            context: context,
            title: "Signup Failed",
            message: signupBody['error'] ?? "Unknown error",
          );
        }
      } else {
        setState(() {
          message = verifyBody["message"] ?? "OTP verification failed";
        });
      }
    } catch (e) {
      setState(() => message = "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            "Verify Email",
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
                  "Check your email",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter the 6-digit code sent to your email",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: widget.email),
                  decoration: const InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
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
                  onPressed: isLoading ? null : verifyOtpAndSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
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

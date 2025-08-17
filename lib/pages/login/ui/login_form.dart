import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/login/repo/login_repo.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/validator.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class ELoginForm extends StatefulWidget {
  const ELoginForm({super.key, required this.onPressed});

  final Function(String email, String password) onPressed;

  @override
  State<ELoginForm> createState() => _ELoginFormState();
}

class _ELoginFormState extends State<ELoginForm> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  bool _obscureText = true; // State for password visibility
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  void removeSpaces(String value) {
    setState(() {
      email.text = value.replaceAll(' ', ''); // Remove all spaces
      email.selection = TextSelection.collapsed(
          offset: email.text.length); // Keep the cursor at the end of the text
    });
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            cursorColor: EColors.primaryColor,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
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
                Icons.email_outlined,
                color: dark
                    ? EColors.white.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.7),
                size: 26.r,
              ),
              labelText: ETexts.email,
              labelStyle: TextStyle(
                  color:
                      dark ? EColors.white.withValues(alpha: 0.7) : Colors.grey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: TextStyle(
                  color: EColors.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
              hintText: '',
              hintStyle: TextStyle(color: dark ? EColors.white : Colors.black),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 16.0.w),
              enabledBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
                borderSide: BorderSide(
                    width: 1.w,
                    color: dark ? EColors.darkerGrey : EColors.darkGrey),
              ),
              focusedBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
                borderSide: BorderSide(
                    width: 1.5.w,
                    color: dark ? EColors.darkGrey : EColors.darkerGrey),
              ),
            ),
            onFieldSubmitted: (value) {
              removeSpaces(value);
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            onChanged: removeSpaces,
          ),
          SizedBox(
            height: ESizes.spaceBtwInputFields.h,
          ),
          TextFormField(
            controller: pass,
            focusNode: passwordFocusNode,
            cursorColor: EColors.primaryColor,
            autofocus: false,
            obscureText: _obscureText,
            style: TextStyle(
              color: dark ? EColors.light : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: dark ? EColors.dark : Colors.white,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: dark
                    ? EColors.white.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.7),
                size: 26.r,
              ),
              labelText: ETexts.password,
              labelStyle: TextStyle(
                  color:
                      dark ? EColors.white.withValues(alpha: 0.7) : Colors.grey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: TextStyle(
                  color: EColors.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
              hintText: '',
              hintStyle: TextStyle(color: dark ? EColors.white : Colors.black),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 16.0.w),
              enabledBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
                borderSide: BorderSide(
                    width: 1.w,
                    color: dark ? EColors.darkerGrey : EColors.darkGrey),
              ),
              focusedBorder: OutlineInputBorder().copyWith(
                borderRadius: BorderRadius.circular(ESizes.inputFieldRadius.r),
                borderSide: BorderSide(
                    width: 1.5.w,
                    color: dark ? EColors.darkGrey : EColors.darkerGrey),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: dark
                      ? EColors.white.withValues(alpha: 0.9)
                      : Colors.black,
                  size: 24.r,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            onFieldSubmitted: (value) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Forgot Password
              TextButton(
                onPressed: () async {
                  final loginRepo = LoginRepository(useDev: true);
                  FocusManager.instance.primaryFocus?.unfocus();
                  String? emailError = EValidator.validateEmail(email.text);

                  if (emailError == null) {
                    String eMail = email.text.trim();
                    if (eMail.endsWith(' ')) {
                      eMail = eMail.substring(0, eMail.length - 1);
                    }
                    EFullScreenLoader.openLoadingDialog(
                        "Checking Email...", context);

                    final isExist =
                        await loginRepo.checkEmailExists(email.text.trim());
                    if (isExist == true) {
                      EFullScreenLoader.stopLoading(context);
                      EFullScreenLoader.openLoadingDialog(
                          "Sending OTP...", context);
                      final otpResponse =
                          await loginRepo.sendOtp(email.text.trim());

                      if (otpResponse['success'] == true) {
                        Vibration.vibrate(duration: 100);
                        EFullScreenLoader.stopLoading(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.go('/resetPassword', extra: eMail);
                      } else {
                        EFullScreenLoader.stopLoading(context);
                        Vibration.vibrate(duration: 200);
                        ELoaders.errorSnackBar(
                          context: context,
                          title: 'Oops! Something went wrong',
                          message: otpResponse['error'] ?? 'Failed to send OTP',
                        );
                      }
                    }else{
                      Vibration.vibrate(duration: 200);
                      EFullScreenLoader.stopLoading(context);
                      ELoaders.errorSnackBar(
                        context: context,
                        title: 'Oops! Email doesn\'t exist',
                        message: "Please check your email or SignUp");
                    }
                  } else {
                    Vibration.vibrate(duration: 200);
                    ELoaders.errorSnackBar(
                        context: context,
                        title: 'Oops! Email Field Empty',
                        message: emailError);
                  }
                },
                child: Text(
                  ETexts.forgetPassword,
                  style: TextStyle(
                    color: dark ? Colors.purpleAccent : Colors.purple,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ESizes.md.h,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                widget.onPressed(
                  email.text.trim(),
                  pass.text.trim(),
                );
              },
              child: Text(
                "Login",
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: ESizes.spaceBtwSections.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ETexts.signupTitle,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: dark ? EColors.light : Colors.black),
              ),
              SizedBox(
                width: 4.w,
              ),
              GestureDetector(
                onTap: () {
                  context.push('/signup');
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Colors.blue),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

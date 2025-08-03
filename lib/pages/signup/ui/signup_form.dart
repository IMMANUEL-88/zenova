import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/signup/bloc/signup_bloc.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/validator.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class ESignUpForm extends StatefulWidget {
  const ESignUpForm({super.key, required this.signupPageBloc});
  final SignupBloc signupPageBloc;

  @override
  State<ESignUpForm> createState() => _ESignUpFormState();
}

class _ESignUpFormState extends State<ESignUpForm> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  bool _obscureText = true; // State for password visibility

  // Text Controllers
  final email = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();


  @override
  void dispose() {
    email.dispose();
    lastName.dispose();
    password.dispose();
    firstName.dispose();
    super.dispose();
  }

  // Helper Method to Build TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool isNumPad = false,
    Widget? suffixIcon,
  }) {
    final dark = EHelperFunctions.isDarkMode(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: isNumPad ? TextInputType.phone : TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
          filled: true,
          fillColor: dark ? EColors.dark : Colors.white,
          prefixIcon: Icon(
            prefixIcon,
            color: dark
                ? EColors.white.withValues(alpha: 0.9)
                : Colors.black.withValues(alpha: 0.7),
            size: 26.r,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
              color: dark ? EColors.white.withValues(alpha: 0.7) : Colors.grey,
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
          suffixIcon: suffixIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name and Last Name
          Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: firstName,
                  labelText: ETexts.firstName,
                  prefixIcon: Iconsax.user,
                  validator: (value) =>
                      EValidator.validateEmptyText('First Name', value),
                ),
              ),
              SizedBox(width: ESizes.spaceBtwInputFields.w),
              Expanded(
                child: _buildTextFormField(
                  controller: lastName,
                  labelText: ETexts.lastNome,
                  prefixIcon: Iconsax.user,
                  validator: (value) =>
                      EValidator.validateEmptyText('Last Name', value),
                ),
              ),
            ],
          ),
          SizedBox(height: ESizes.spaceBtwInputFields.h),

          // Email
          _buildTextFormField(
            controller: email,
            labelText: ETexts.email,
            prefixIcon: Iconsax.direct,
            validator: (value) {
              return EValidator.validateEmail(value);
            },
          ),
          SizedBox(height: ESizes.spaceBtwInputFields.h),

          // Password
          _buildTextFormField(
            controller: password,
            labelText: ETexts.password,
            prefixIcon: Iconsax.password_check,
            validator: (value) => EValidator.validatePassword(value),
            obscureText: _obscureText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color:
                    dark ? EColors.white.withValues(alpha: 0.9) : EColors.dark,
                size: 24.r,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
          ),

          SizedBox(height: ESizes.spaceBtwItems.h),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // widget.createAccountPressed?.call();
                  widget.signupPageBloc.add(
                    CreateAccountClickedEvent(
                        firstName: firstName.text.trim(),
                        lastName: lastName.text.trim(),
                        context: context,
                        email: email.text.trim(),
                        password: password.text),
                  );
                } else {
                  ELoaders.errorSnackBar(
                      context: context,
                      title: "Form Invalid",
                      message: "requirements not met");
                }
              },
              child: Text(
                ETexts.createAccount,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

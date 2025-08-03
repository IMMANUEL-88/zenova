import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/signup/bloc/signup_bloc.dart';
import 'package:zenova/pages/signup/ui/signup_form.dart';
import 'package:zenova/pages/signup/ui/social_button_signup.dart';
import 'package:zenova/popups/loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/device_utils.dart';
import 'package:zenova/utils/shimmer_effects.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/appbar.dart';
import 'form_divider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final SignupBloc signupPageBloc = SignupBloc();

class _SignUpScreenState extends State<SignUpScreen> {
  late rive.RiveAnimationController _controller;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isRiveLoaded = false;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: EColors.white,
    //   statusBarIconBrightness: Brightness.dark,
    //   systemNavigationBarColor: EColors.white,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
    signupPageBloc.add(SignUpPageInitialEvent());
    _controller = rive.SimpleAnimation('Timeline 1', autoplay: true);
    _startListening();
  }

  void _startListening() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isOffline = results.contains(ConnectivityResult.none);

      if (isOffline) {
        signupPageBloc.add(SignUpPageNoInternetEvent());
      } else {
        signupPageBloc.add(SignUpPageInitialEvent());
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return BlocConsumer<SignupBloc, SignupState>(
      bloc: signupPageBloc,
      listenWhen: (previous, current) => current is SignupActionState,
      buildWhen: (previous, current) => current is! SignupActionState,
      listener: (context, state) {
        if (state is SignUpPageCreateAccountState) {
          //print('Create Account Clicked');
        }
        if (state is SignUpPageGoogleSignUpState) {
          //print('Google Sign Up Clicked');
        }
        if (state is SignUpPageFacebookSignUpState) {
          //print('Facebook Sign Up Clicked');
        }
        if (state is SignUpPageError) {
          ELoaders.errorSnackBar(
              context: context,
              title: "Oops! Something went wrong",
              message: state.errorMessage);
        }
        if(state is SignUpPageLoginNavigateState) {
          ELoaders.successSnackBar(
            context: context,
            title: 'Yay! Good Job',
            message: 'Account created successfully. Please Login.',
          );
          context.go('/');
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (SignUpPageNoInternetState):
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0.3.sh,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (!_isRiveLoaded)
                              Padding(
                                padding: EdgeInsets.all(
                                  8.0.r,
                                ),
                                child: EShimmerEffect(
                                  width: double.infinity,
                                  height: double.infinity,
                                  radius: 20.r,
                                ),
                              ),
                            Opacity(
                              opacity: _isRiveLoaded ? 1 : 0,
                              child: rive.RiveAnimation.asset(
                                EImages.noInternet,
                                fit: BoxFit.cover,
                                controllers: [_controller],
                                onInit: (_) {
                                  setState(() {
                                    _isRiveLoaded = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Oops! No Internet Connection...',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () async {
                          bool isConnected =
                              await EDeviceUtils.hasInternetConnection();
                          if (isConnected) {
                            signupPageBloc.add(SignUpPageInitialEvent());
                          } else {
                            ELoaders.errorSnackBar(
                              context: context,
                              title: 'Oops! No Internet Connection...',
                              message:
                                  'Please Check Your Internet Connection and Try Again',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          minimumSize: Size(0.21.sw, 0.05.sh),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 10.w),
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          case const (SignupPageLoading):
            return Scaffold(
              appBar: EAppBar(
                appBarColor: dark ? EColors.dark : EColors.light,
                showBackArrow: true,
              ),
              body: Center(
                child: EAnimationLoaderWidget(
                  text: 'Loading...',
                  image: dark
                      ? EImages.darkLoadingAppLogo
                      : EImages.lightLoadingAppLogo,
                ),
              ),
            );

          case const (SignUpPageLoaded):
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: EAppBar(
                  appBarColor: dark ? EColors.dark : EColors.light,
                  showBackArrow: true,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(ESizes.defaultSpace.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Title
                        Text(
                          ETexts.signupTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),

                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),

                        //Form

                        ESignUpForm(
                          signupPageBloc: signupPageBloc,
                        ),

                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),

                        //Divider
                        EFormDivider(
                          dividerText: ETexts.orsignUpWith,
                        ),

                        SizedBox(
                          height: ESizes.spaceBtwItems.h,
                        ),

                        //Social Buttons
                        ESocialButtonsSignUp(
                          onGooglePressed: () {
                            signupPageBloc.add(
                                GoogleSignUpClickedEvent(context: context));
                          },
                          onFacebookPressed: () async {
                            signupPageBloc.add(
                                FacebookSignUpClickedEvent(context: context));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          default:
            return Scaffold(
              appBar: EAppBar(
                appBarColor: dark ? EColors.dark : EColors.light,
                showBackArrow: true,
              ),
              body: Center(
                child: EAnimationLoaderWidget(
                  text: 'Loading...',
                  image: dark
                      ? EImages.darkLoadingAppLogo
                      : EImages.lightLoadingAppLogo,
                ),
              ),
            );
        }
      },
    );
  }
}

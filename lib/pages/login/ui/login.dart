import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vibration/vibration.dart';
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/constants/spacing.dart';
import 'package:zenova/constants/text_strings.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/pages/login/bloc/login_bloc.dart';
import 'package:zenova/pages/login/ui/form_divider.dart';
import 'package:zenova/pages/login/ui/login_form.dart';
import 'package:zenova/pages/login/ui/social_button_login.dart';
import 'package:zenova/popups/loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/device_utils.dart';
import 'package:zenova/utils/shimmer_effects.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // late final LoginBloc loginBloc;
  final LoginBloc loginBloc = LoginBloc();
  late rive.RiveAnimationController _controller;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isRiveLoaded = false;

  @override
  void initState() {
    super.initState();
    loginBloc.add(LoginInitialEvent());
    _controller = rive.SimpleAnimation('Timeline 1', autoplay: true);
    _startListening();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDarkMode = EHelperFunctions.isDarkMode(context);
    _updateSystemUI(isDarkMode);
  }

  void _updateSystemUI(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDarkMode ? Color(0xFF0f0f0f) : Color(0xFFF7F7F7),
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness:
          isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  void _startListening() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isOffline = results.contains(ConnectivityResult.none);

      if (isOffline) {
        Vibration.vibrate(duration: 200);
        loginBloc.add(LoginNoInternetEvent());
      } else {
        loginBloc.add(LoginInitialEvent());
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
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginPageVerifyOTPNavigateState) {
          ELoaders.successSnackBar(
              context: context,
              title: "Yay! Your credentials are right",
              message: state.message);
          context.go('/otp', extra: state.email);
        }
        if (state is LoginErrorState) {
          ELoaders.errorSnackBar(
              context: context,
              title: "Oops! Something went wrong",
              message: state.errorMessage);
        }
        if (state is LoginLoadingState) {
          Center(
            child: EAnimationLoaderWidget(
              image: dark
                  ? EImages.darkLoadingAppLogo
                  : EImages.lightLoadingAppLogo,
              text: "Loading...",
            ),
          );
        }
        if (state is GoogleSignInClickedState) {
          // Navigate to the home screen
          context.go('/');
          // Show a success message
          ELoaders.successSnackBar(
            context: context,
            message: "Welcome back User.",
            title: "Yay! Login Successful",
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (LoginNoInternetState):
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
                            loginBloc.add(LoginInitialEvent());
                          } else {
                            Vibration.vibrate(duration: 200);
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

          case const (LoginLoadedState):
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: ESpacingStyle.paddingWithAppBarHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),
                        SizedBox(
                          height: 140.h,
                          child: Image(
                            image: AssetImage(dark
                                ? EImages.loginLogoDark
                                : EImages.loginLogoLight),
                          ),
                        ),
                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),
                        Text(
                          ETexts.loginTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: dark ? EColors.white : Colors.black),
                        ),
                        SizedBox(
                          height: ESizes.xs.h,
                        ),
                        Text(
                          ETexts.loginSubTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: dark ? EColors.white : Colors.black,
                          ),
                          //style: TextStyle(color: Colors.black, fontSize: 45),
                        ),
                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),

                        ELoginForm(
                          onPressed: (String email, String password) {
                            loginBloc.add(
                              LoginPageLoginClickedEvent(
                                  email: email,
                                  password: password,
                                  context: context),
                            );
                          },
                        ),
                        SizedBox(
                          height: ESizes.spaceBtwSections.h,
                        ),

                        //Form Divider
                        EFormDivider(
                          dividerText: ETexts.orSignInWith,
                        ),

                        SizedBox(height: ESizes.spaceBtwInputFields.h),

                        //Social Buttons
                        ESocialButtonsLogin(
                          onGooglePressed: () {
                            loginBloc.add(
                                GoogleSignInClickedEvent(context: context));
                          },
                          onFacebookPressed: () async {
                            loginBloc.add(
                                FacebookSignInClickedEvent(context: context));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          default:
            return Scaffold(
              body: Center(
                child: EAnimationLoaderWidget(
                  image: dark
                      ? EImages.darkLoadingAppLogo
                      : EImages.lightLoadingAppLogo,
                  text: "Loading...",
                ),
              ),
            );
        }
      },
    );
  }
}

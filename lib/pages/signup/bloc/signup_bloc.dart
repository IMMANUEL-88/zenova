import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenova/pages/login/repo/login_repo.dart';
import 'package:zenova/pages/signup/repo/signup_repo.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/device_utils.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignUpPageInitialEvent>(signUpPageInitialEvent);
    on<CreateAccountClickedEvent>(createAccountClickedEvent);
    on<GoogleSignUpClickedEvent>(googleSignUpClickedEvent);
    on<FacebookSignUpClickedEvent>(facebookSignUpClickedEvent);
    on<SignUpPageNoInternetEvent>(signUpNoInternetEvent);
  }

  FutureOr<void> signUpPageInitialEvent(
      SignUpPageInitialEvent event, Emitter<SignupState> emit) async {
    bool isConnected = await EDeviceUtils.hasInternetConnection();
    if (isConnected) {
      emit(SignUpPageLoaded());
    } else {
      emit(SignUpPageNoInternetState());
    }
  }

  FutureOr<void> createAccountClickedEvent(
      CreateAccountClickedEvent event, Emitter<SignupState> emit) async {
    final BuildContext context = event.context;
    EFullScreenLoader.openLoadingDialog("Creating Account...", context);

    try {
      final loginRepo = LoginRepository(useDev: true);
      // Handle OTP sending
      final otpResponse = await loginRepo.sendOtp(event.email);

      if (otpResponse['success'] == true) {
        // Navigate to OTP verification page
        context.go('/signUpVerifyOtp', extra: {
        "email": event.email,
        "password": event.password,
        "firstName": event.firstName,
        "lastName": event.lastName,
      });
      } else {
        EFullScreenLoader.stopLoading(event.context);
        emit(SignUpPageError(
          errorMessage: otpResponse['error'] ?? 'Failed to send OTP',
        ));
      }

      // final signUpRepo = SignUpRepository(useDev: true);
      // final response = await signUpRepo.signUpUser(
      //   event.email,
      //   event.password,
      //   event.firstName,
      //   event.lastName,
      // );
      // if (response['success'] == true) {
      //   EFullScreenLoader.stopLoading(context);
      //   emit(SignUpPageLoginNavigateState());
      // } else {
      //   EFullScreenLoader.stopLoading(context);
      //   emit(SignUpPageError(
      //       errorMessage: response['error'] ?? 'Unknown error'));
      // }
    } catch (e) {
      EFullScreenLoader.stopLoading(context);
      emit(SignUpPageError(errorMessage: e.toString()));
      return;
    }
  }

  FutureOr<void> googleSignUpClickedEvent(
      GoogleSignUpClickedEvent event, Emitter<SignupState> emit) async {
    EFullScreenLoader.openLoadingDialog("Loading...", event.context);
    Future.delayed(const Duration(seconds: 2), () {
      EFullScreenLoader.stopLoading(event.context);
    });
  }

  FutureOr<void> facebookSignUpClickedEvent(
      FacebookSignUpClickedEvent event, Emitter<SignupState> emit) {
    ELoaders.warningSnackBar(
        context: event.context,
        title: 'Oops! Feature Unavailable.',
        message: 'This Feature is Not Available Yet.');
  }

  FutureOr<void> signUpNoInternetEvent(
      SignUpPageNoInternetEvent event, Emitter<SignupState> emit) {
    emit(SignUpPageNoInternetState());
  }
}

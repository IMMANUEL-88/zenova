import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zenova/pages/login/repo/login_repo.dart';
import 'package:zenova/popups/fullscreen_loaders.dart';
import 'package:zenova/popups/snackbar.dart';
import 'package:zenova/utils/device_utils.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginPageLoginClickedEvent>(loginPageLoginClickedEvent);
    on<LoginPageForgotPasswordClickedEvent>(
        loginPageForgotPasswordClickedEvent);
    on<GoogleSignInClickedEvent>(googleSignInClickedEvent);
    on<FacebookSignInClickedEvent>(facebookSignInClickedEvent);
    on<LoginNoInternetEvent>(loginNoInternetEvent);
  }
  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    bool isConnected = await EDeviceUtils.hasInternetConnection();
    if (isConnected) {
      emit(LoginLoadedState());
    } else {
      emit(LoginNoInternetState());
    }
  }

  FutureOr<void> loginPageLoginClickedEvent(
      LoginPageLoginClickedEvent event, Emitter<LoginState> emit) async {
    EFullScreenLoader.openLoadingDialog("Logging in...", event.context);

    if (event.email.isEmpty || event.password.isEmpty) {
      EFullScreenLoader.stopLoading(event.context);
      emit(LoginErrorState(errorMessage: "Email and Password cannot be empty"));
      return;
    }

    try {
      final loginRepo = LoginRepository(useDev: true);
      final response = await loginRepo.loginUser(event.email, event.password);

      if (response['success'] == true) {
        await HiveStorageHelper.setUserEmail(event.email);

        if (response['user'] != null && response['user']['name'] != null) {
          await HiveStorageHelper.setUserName(response['user']['name']);
          await HiveStorageHelper.setUserId(response['user']['userId']);
        }

        // EFullScreenLoader.stopLoading(event.context);
        //   emit(LoginPageVerifyOTPNavigateState(
        //     email: event.email,
        //     message: "Message",
        //   ));



        // Handle OTP sending
        final otpResponse = await loginRepo.sendOtp(event.email);

        if (otpResponse['success'] == true) {
          EFullScreenLoader.stopLoading(event.context);
          emit(LoginPageVerifyOTPNavigateState(
            email: event.email,
            message: otpResponse['message'],
          ));
        } else {
          EFullScreenLoader.stopLoading(event.context);
          emit(LoginErrorState(
            errorMessage: otpResponse['error'] ?? 'Failed to send OTP',
          ));
        }
      } else {
        EFullScreenLoader.stopLoading(event.context);
        emit(
            LoginErrorState(errorMessage: response['error'] ?? 'Login failed'));
      }
    } catch (e) {
      EFullScreenLoader.stopLoading(event.context);
      emit(LoginErrorState(
          errorMessage: 'Something went wrong. Please try again.'));
    }
  }

  FutureOr<void> loginPageForgotPasswordClickedEvent(
      LoginPageForgotPasswordClickedEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> googleSignInClickedEvent(
      GoogleSignInClickedEvent event, Emitter<LoginState> emit) async {
    EFullScreenLoader.openLoadingDialog(
        'Logging in with Google...', event.context);

    await Future.delayed(Duration(seconds: 2));

    EFullScreenLoader.stopLoading(event.context);
    emit(GoogleSignInClickedState()); // Emit success state
    // try {
    //   bool isSuccessful = await AuthService().signInWithGoogle(event.context);
    //   if (isSuccessful) {
    //     final prefs = await SharedPreferences.getInstance();
    //     String? email = prefs.getString('userId');
    //     await FetchUserDetails().userDetails(email!);
    //     String? userId = prefs.getString('userId');
    //     //String? fcmToken = prefs.getString('fcmToken');
    //     String fCMToken = await FirebaseApi().initNotifications();
    //     bool result = await Api().addFcmToTopic(userId, fCMToken);
    //     if (result) {
    //       EFullScreenLoader.stopLoading(event.context);
    //       emit(GoogleSignInClickedState()); // Emit success state
    //     }
    //   } else {
    //     EFullScreenLoader.stopLoading(event.context);
    //     await AuthService().signOut();
    //     emit(LoginErrorState(errorMessage: "Google sign-in failed"));
    //   }
    // } catch (e) {
    //   return;
    // }
  }

  FutureOr<void> loginNoInternetEvent(
      LoginNoInternetEvent event, Emitter<LoginState> emit) {
    emit(LoginNoInternetState());
  }

  FutureOr<void> facebookSignInClickedEvent(
      FacebookSignInClickedEvent event, Emitter<LoginState> emit) {
    ELoaders.warningSnackBar(
        context: event.context,
        title: 'Oops! Feature Unavailable.',
        message: 'This Feature is Not Available Yet.');
  }
}

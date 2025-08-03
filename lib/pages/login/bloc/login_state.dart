part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

sealed class LoginActionState extends LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginActionState {}

final class LoginLoadedState extends LoginState {}

final class LoginErrorState extends LoginActionState {
  final String errorMessage;

  LoginErrorState({required this.errorMessage});
}

final class LoginPageLoginClickedState extends LoginState {
  final String email;
  final String password;
  final String role;

  LoginPageLoginClickedState(
      {required this.email, required this.password, required this.role});
}

final class GoogleSignInClickedState extends LoginActionState {}

final class FacebookSignInClickedState extends LoginActionState {}

// Action State
final class LoginPageForgotPasswordClickedState extends LoginActionState {
  final String email;

  LoginPageForgotPasswordClickedState({required this.email});
}

final class LoginPageHomeNavigateState extends LoginActionState {}

final class LoginPageVerifyOTPNavigateState extends LoginActionState {
  final String email;
  final String message;

  LoginPageVerifyOTPNavigateState({required this.email, required this.message});
}

final class LoginNoInternetState extends LoginState {}

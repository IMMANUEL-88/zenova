part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginInitialEvent extends LoginEvent {}

final class LoginPageForgotPasswordClickedEvent extends LoginEvent {
  final String email;

  LoginPageForgotPasswordClickedEvent({required this.email});
}

final class LoginPageLoginClickedEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginPageLoginClickedEvent(
      {required this.email, required this.password, required this.context});
}

final class GoogleSignInClickedEvent extends LoginEvent {
  final BuildContext context;

  GoogleSignInClickedEvent({required this.context});
}

final class FacebookSignInClickedEvent extends LoginEvent {
  final BuildContext context;

  FacebookSignInClickedEvent({required this.context});
}

final class LoginPageDashNavigateEvent extends LoginEvent {}

final class LoginNoInternetEvent extends LoginEvent {}

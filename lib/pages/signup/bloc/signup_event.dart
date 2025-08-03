part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignUpPageInitialEvent extends SignupEvent {}

class CreateAccountClickedEvent extends SignupEvent {
  final String firstName;
  final String lastName;
  final BuildContext context;
  final String email;
  final String password;

  CreateAccountClickedEvent(
      {required this.firstName,
      required this.lastName,
      required this.context,
      required this.email,
      required this.password});
}

class GoogleSignUpClickedEvent extends SignupEvent {
  final BuildContext context;

  GoogleSignUpClickedEvent({required this.context});
}

class FacebookSignUpClickedEvent extends SignupEvent {
  final BuildContext context;

  FacebookSignUpClickedEvent({required this.context});
}

final class SignUpPageNoInternetEvent extends SignupEvent {}

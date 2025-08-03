part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

sealed class SignupActionState extends SignupState {}

final class SignupPageInitial extends SignupState {}

class SignupPageLoading extends SignupState {}

class SignUpPageLoaded extends SignupState {}

class SignUpPageError extends SignupState {
  final String errorMessage;

  SignUpPageError({required this.errorMessage});
}

// Action Satates
class SignUpPageCreateAccountState extends SignupActionState {}

class SignUpPageLoginNavigateState extends SignupActionState {}

class SignUpPageGoogleSignUpState extends SignupActionState {}

class SignUpPageFacebookSignUpState extends SignupActionState {}

final class SignUpPageNoInternetState extends SignupState {}

part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}


class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel data;

  LoginSuccess(this.data);
}

class LoginError extends LoginState {
  final LoginErrorModel errorMessage;

  LoginError(this.errorMessage);
}




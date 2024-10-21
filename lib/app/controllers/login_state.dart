import '../model/token_model.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String username;

  final Token token;

  LoginSuccess(this.username, this.token);
}

class LoginError extends LoginState {
  final dynamic error;

  LoginError(this.error);
}

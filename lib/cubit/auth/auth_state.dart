import 'package:gtrack_nartec/models/auth/LoginResponseModel.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponseModel;

  LoginSuccess(this.loginResponseModel);
}

class LoginFailure extends LoginState {
  String error;

  LoginFailure(this.error);
}

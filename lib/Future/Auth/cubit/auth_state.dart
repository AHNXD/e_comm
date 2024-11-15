part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class SignUpState extends AuthState {}

final class GenderState extends AuthState {}

final class SwitchState extends AuthState {}

//----------------------------------------------------------------
// Register
final class RegisterLoadingState extends AuthState {}

final class RegisterSuccessfulState extends AuthState {
  final String? msg;
  RegisterSuccessfulState([this.msg]);
}

final class RegisterErrorState extends AuthState {
  final String message;
  RegisterErrorState(this.message);
}

//----------------------------------------------------------------
//LogIn
final class LoginLoadingState extends AuthState {}

final class LoginSuccessfulState extends AuthState {
  final String? msg;
  LoginSuccessfulState([this.msg]);
}

final class LoginErrorState extends AuthState {
  final String message;
  LoginErrorState(this.message);
}

//----------------------------------------------------------------
//LogOut
final class LogoutLoadingState extends AuthState {}

final class LogoutSuccessState extends AuthState {
  final String message;

  LogoutSuccessState({required this.message});
}

final class LogoutErrorState extends AuthState {
  final String message;
  LogoutErrorState(this.message);
}

//----------------------------------------------------------------
//Token
final class IsVaildToken extends AuthState {}

final class IsNotVaildToken extends AuthState {}

final class TokenLoadingState extends AuthState {}

final class TokenErrorState extends AuthState {
  final String message;
  TokenErrorState(this.message);
}

//----------------------------------------------------------------
//Reset Password
final class ResetPasswordLoadingState extends AuthState {}

final class ResetPasswordSuccessfulState extends AuthState {
  final String? msg;
  ResetPasswordSuccessfulState([this.msg]);
}

final class ResetPasswordErrorState extends AuthState {
  final String message;
  ResetPasswordErrorState(this.message);
}

//----------------------------------------------------------------
//Forget Password
final class ForgetPasswordLoadingState extends AuthState {}

final class ForgetPasswordSuccessfulState extends AuthState {
  final String? msg;
  ForgetPasswordSuccessfulState([this.msg]);
}

final class ForgetPasswordErrorState extends AuthState {
  final String message;
  ForgetPasswordErrorState(this.message);
}
//----------------------------------------------------------------
part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessfulState extends AuthState {
  final String? msg;
  AuthSuccessfulState([this.msg]);
}

final class SignUpState extends AuthState {}

final class GenderState extends AuthState {}

final class SwitchState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}

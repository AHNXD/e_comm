part of 'contact_us_cubit.dart';

@immutable
sealed class ContactUsState {}

final class ContactUsInitial extends ContactUsState {}

final class ContactUsErrorState extends ContactUsState {
  final String error;

  ContactUsErrorState({required this.error});
}

final class ContactUsSuccessfulState extends ContactUsState {
  final String msg;

  ContactUsSuccessfulState({required this.msg});
}

final class ContactUsLoadingState extends ContactUsState {}

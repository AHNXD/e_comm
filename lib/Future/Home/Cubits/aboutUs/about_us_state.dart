part of 'about_us_cubit.dart';

@immutable
sealed class AboutUsState {}

final class AboutUsInitial extends AboutUsState {}

final class GetAboutUsLoadingState extends AboutUsState {}

final class GetAboutUsErrorState extends AboutUsState {
  final String msg;
  GetAboutUsErrorState(this.msg);
}

final class GetAboutUsSuccessfulState extends AboutUsState {
  final AboutUsModel aboutUs;
  final Links links;

  GetAboutUsSuccessfulState({required this.aboutUs, required this.links});
}

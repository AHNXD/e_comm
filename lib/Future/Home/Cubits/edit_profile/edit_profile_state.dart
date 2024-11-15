part of 'edit_profile_cubit.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {
  final String msg;

  const EditProfileSuccess({required this.msg});
}

final class EditProfileError extends EditProfileState {
  final String msg;

  const EditProfileError({required this.msg});
}

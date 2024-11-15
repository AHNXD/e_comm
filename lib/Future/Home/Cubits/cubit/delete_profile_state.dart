part of 'delete_profile_cubit.dart';

sealed class DeleteProfileState extends Equatable {
  const DeleteProfileState();

  @override
  List<Object> get props => [];
}

final class DeleteProfileInitial extends DeleteProfileState {}

final class DeleteProfileSuccess extends DeleteProfileState {
  final String msg;

  const DeleteProfileSuccess({required this.msg});
}

final class DeleteProfileError extends DeleteProfileState {
  final String msg;

  const DeleteProfileError({required this.msg});
}

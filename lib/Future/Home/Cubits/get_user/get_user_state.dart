part of 'get_user_cubit.dart';

sealed class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object> get props => [];
}

final class GetUserInitial extends GetUserState {}

final class GetUserSuccess extends GetUserState {
  final UserProfile userProfile;

  const GetUserSuccess({required this.userProfile});
}

final class GetUserLoadin extends GetUserState {}

final class GetUserErorre extends GetUserState {
  final String msg;

  const GetUserErorre({required this.msg});
}

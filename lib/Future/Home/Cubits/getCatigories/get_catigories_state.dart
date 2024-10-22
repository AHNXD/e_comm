part of 'get_catigories_cubit.dart';

@immutable
sealed class GetCatigoriesState {}

final class GetCatigoriesInitial extends GetCatigoriesState {}

final class SetIdState extends GetCatigoriesState {}

final class GetCatigoriesLoadingState extends GetCatigoriesState {}

final class GetCatigoriesErrorState extends GetCatigoriesState {
  final String msg;
  GetCatigoriesErrorState(this.msg);
}

final class GetCatigoriesSuccessfulState extends GetCatigoriesState {}

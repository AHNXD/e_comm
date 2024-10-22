part of 'get_catigories_offers_cubit.dart';

@immutable
sealed class GetCatigoriesOffersState {}

final class GetCatigoriesOffersInitial extends GetCatigoriesOffersState {}

final class GetCatigoriesOffersSuccessfulState
    extends GetCatigoriesOffersState {}

final class GetCatigoriesOffersLoadingState extends GetCatigoriesOffersState {}

final class GetCatigoriesOffersErrorState extends GetCatigoriesOffersState {
  final String msg;
  GetCatigoriesOffersErrorState(this.msg);
}

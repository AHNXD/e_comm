part of 'get_offers_cubit.dart';

@immutable
sealed class GetOffersState {}

final class GetOffersInitial extends GetOffersState {}

final class GetOffersSuccessfulState
    extends GetOffersState {}

final class GetOffersLoadingState extends GetOffersState {}

final class GetOffersErrorState extends GetOffersState {
  final String msg;
  GetOffersErrorState(this.msg);
}
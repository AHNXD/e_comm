part of 'get_offers_bloc.dart';

sealed class GetOffersEvent extends Equatable {
  const GetOffersEvent();

  @override
  List<Object> get props => [];
}

class GetAllOffersEvent extends GetOffersEvent {}

class ResetPaginationAllOffersEvent extends GetOffersEvent {}

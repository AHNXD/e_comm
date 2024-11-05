part of 'get_latest_products_bloc.dart';

sealed class GetLatestProductsEvent extends Equatable {
  const GetLatestProductsEvent();

  @override
  List<Object> get props => [];
}

class GetAllLatestProductsEvent extends GetLatestProductsEvent {}

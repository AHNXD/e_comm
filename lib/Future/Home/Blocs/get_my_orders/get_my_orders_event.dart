part of 'get_my_orders_bloc.dart';

sealed class GetMyOrdersEvent extends Equatable {
  const GetMyOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetAllMyOrdersEvent extends GetMyOrdersEvent {}

class RestPagination extends GetMyOrdersEvent {}

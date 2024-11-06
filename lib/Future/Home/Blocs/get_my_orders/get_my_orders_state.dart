part of 'get_my_orders_bloc.dart';

sealed class GetMyOrdersState extends Equatable {
  const GetMyOrdersState();
  
  @override
  List<Object> get props => [];
}

final class GetMyOrdersInitial extends GetMyOrdersState {}

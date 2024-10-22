part of 'get_my_orders_cubit.dart';

@immutable
sealed class GetMyOrdersState {}

final class GetMyOrdersInitial extends GetMyOrdersState {}

final class GetMyOrdersSuccessfulState extends GetMyOrdersState {
  final OrdersInformation orderInformation;

  GetMyOrdersSuccessfulState({required this.orderInformation});
}

final class GetMyOrdersLoadingState extends GetMyOrdersState {}

final class GetMyOrdersErrorState extends GetMyOrdersState {
  final String msg;
  GetMyOrdersErrorState(this.msg);
}

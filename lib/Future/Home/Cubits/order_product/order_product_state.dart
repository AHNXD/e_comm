part of 'order_product_cubit.dart';

sealed class OrderProductState extends Equatable {
  const OrderProductState();

  @override
  List<Object> get props => [];
}

final class OrderPoductInitial extends OrderProductState {}

class OrderProductSuccess extends OrderProductState {
  final String msg;
  OrderProductSuccess({required this.msg});
}

class OrderProductError extends OrderProductState {
  final String error;
  OrderProductError({required this.error});
}

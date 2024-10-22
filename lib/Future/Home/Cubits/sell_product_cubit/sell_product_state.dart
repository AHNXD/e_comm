part of 'sell_product_cubit.dart';

@immutable
sealed class SellProductState {}

final class SellProductInitial extends SellProductState {}

final class SellProductLoading extends SellProductState {}

final class SellProductSuccess extends SellProductState {
  final String msg;

  SellProductSuccess({required this.msg});
}

final class SellProductError extends SellProductState {
  final String error;

  SellProductError({required this.error});
}

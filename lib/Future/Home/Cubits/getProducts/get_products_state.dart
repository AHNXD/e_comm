part of 'get_products_cubit.dart';

 
sealed class GetProductsState {}

final class GetProductsInitial extends GetProductsState {}

final class GetProductsLoadingState extends GetProductsState {}

final class GetProductsErrorState extends GetProductsState {
  final String msg;
  GetProductsErrorState(this.msg);
}

final class GetProductsSuccessfulState extends GetProductsState {}

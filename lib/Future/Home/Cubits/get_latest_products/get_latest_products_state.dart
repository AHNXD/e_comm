part of 'get_latest_products_cubit.dart';

@immutable
sealed class GetLatestProductsState {}

final class GetLatestProductsInitial extends GetLatestProductsState {}

final class GetLatestProductsLoadingState extends GetLatestProductsState {}

final class GetLatestProductsErrorState extends GetLatestProductsState {
  final String msg;
  GetLatestProductsErrorState(this.msg);
}

final class GetLatestProductsSuccessfulState extends GetLatestProductsState {
  final List<LatestProducts> latestProducts;

  GetLatestProductsSuccessfulState({required this.latestProducts});
}

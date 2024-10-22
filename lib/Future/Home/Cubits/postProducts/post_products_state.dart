part of 'post_products_cubit.dart';

@immutable
sealed class PostProductsState {}

final class PostProductsInitial extends PostProductsState {}

final class PostProductsLoadingState extends PostProductsState {}

final class PostProductsErrorState extends PostProductsState {
  final String msg;
  PostProductsErrorState(this.msg);
}

final class PostProductsSuccessfulState extends PostProductsState {}

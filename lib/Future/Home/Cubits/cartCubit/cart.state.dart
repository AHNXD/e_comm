part of 'cart.bloc.dart';

@immutable
sealed class CartState {}

final class AddToCartState extends CartState {}

final class RemvoeFromCartState extends CartState {
  final List<MainProduct> porducts;

  RemvoeFromCartState({required this.porducts});
}

final class AlreadyInCartState extends CartState {}

final class EmptyCartState extends CartState {}

final class CartLoadingState extends CartState {}

final class CartRefreshState extends CartState {
  final List<MainProduct> loadedporduct;

  CartRefreshState({required this.loadedporduct});
}

final class CartErrorState extends CartState {
  final String errorMessage;

  CartErrorState({required this.errorMessage});
}

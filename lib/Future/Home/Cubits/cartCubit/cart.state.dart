part of 'cart.bloc.dart';

@immutable
sealed class CartState {}

final class GetCartSuccessfulState extends CartState {}

final class AlreadyInCartState extends CartState {}

final class AddToCartState extends CartState {}

final class AlreadyInCartFromCatState extends CartState {}

final class AddToCartFromCatState extends CartState {}

final class AlreadyInCartFromSearchState extends CartState {}

final class AddToCartFromSearchState extends CartState {}

final class AlreadyInCartFromFavState extends CartState {}

final class AddToCartFromFavState extends CartState {}

final class AlreadyInCartFromHomeState extends CartState {}

final class AddedTocartFromHomeScreen extends CartState {}

final class EmptyCartState extends CartState {}

final class CartLoadingState extends CartState {}

final class CartErrorState extends CartState {
  final String errorMessage;

  CartErrorState({required this.errorMessage});
}

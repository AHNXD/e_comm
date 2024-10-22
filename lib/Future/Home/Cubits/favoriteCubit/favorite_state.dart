part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteAddState extends FavoriteState {}

final class FavoriteProductSuccessfulState extends FavoriteState {
  final bool isFave;

  FavoriteProductSuccessfulState({required this.isFave});
}

final class GetFavoriteProductsLoadingState extends FavoriteState {}

final class FavoriteProductsErrorState extends FavoriteState {
  final String message;
  FavoriteProductsErrorState(this.message);
}

final class GetFavoriteProductsSuccessfulState extends FavoriteState {
  final List<MainProduct>? fvModel;

  GetFavoriteProductsSuccessfulState({required this.fvModel});
}

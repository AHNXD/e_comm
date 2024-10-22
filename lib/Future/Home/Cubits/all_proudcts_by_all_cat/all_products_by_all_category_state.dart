part of 'all_products_by_all_category_cubit.dart';

@immutable
sealed class AllProductsByAllCategoryState {}

final class AllProductsByAllCategoryInitial
    extends AllProductsByAllCategoryState {}

final class AllProductsByAllCategorySuccess
    extends AllProductsByAllCategoryState {
  final List<List<MainProduct>> allProducts;

  AllProductsByAllCategorySuccess({required this.allProducts});
}

final class AllProductsByAllCategoryLoading
    extends AllProductsByAllCategoryState {}

final class AllProductsByAllCategoryError
    extends AllProductsByAllCategoryState {
  final String msg;

  AllProductsByAllCategoryError({required this.msg});
}

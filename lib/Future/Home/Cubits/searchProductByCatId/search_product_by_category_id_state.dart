part of 'search_product_by_category_id_cubit.dart';

@immutable
sealed class SearchProductByCategoryIdState {}

final class SearchProductByCategoryIdInitial
    extends SearchProductByCategoryIdState {
  late final List<MainProduct> product;
}

final class SearchProductByCategoryIdSuccess
    extends SearchProductByCategoryIdState {
  final List<MainProduct> products;

  SearchProductByCategoryIdSuccess({required this.products});
}

final class SearchProductByCategoryIdLoading
    extends SearchProductByCategoryIdState {}

final class SearchProductByCategoryIdNotFound
    extends SearchProductByCategoryIdState {}

final class SearchProductByCategoryIdError
    extends SearchProductByCategoryIdState {
  final String message;

  SearchProductByCategoryIdError({required this.message});
}

part of 'search_products_bloc.dart';

enum SearchProductsStatus {
  init,
  loading,
  success,
  error,
}

class SearchProductsState extends Equatable {
  final SearchProductsStatus status;
  final List<MainProduct> products;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;
  const SearchProductsState({
    this.status = SearchProductsStatus.loading,
    this.hasReachedMax = false,
    this.products = const [],
    this.errorMsg = "",
    this.totalPages = 1,
    this.currentPage = 1,
  });
  SearchProductsState copyWith(
      {SearchProductsStatus? status,
      List<MainProduct>? products,
      bool? hasReachedMax,
      String? errorMsg,
      int? currentPage,
      int? totalPages}) {
    return SearchProductsState(
        status: status ?? this.status,
        products: products ?? this.products,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        errorMsg: errorMsg ?? this.errorMsg,
        currentPage: currentPage ?? this.currentPage,
        totalPages: currentPage ?? this.currentPage);
  }

  @override
  List<Object> get props => [
        status,
        products,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages,
      ];
}

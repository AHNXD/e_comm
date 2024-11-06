part of 'search_filter_poducts_bloc.dart';

enum SearchFilterProductsStatus { loading, success, error, init }

class SearchFilterPoductsState extends Equatable {
  final SearchFilterProductsStatus status;
  final List<MainProduct> products;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;
  const SearchFilterPoductsState({
    this.status = SearchFilterProductsStatus.init,
    this.hasReachedMax = false,
    this.products = const [],
    this.errorMsg = "",
    this.totalPages = 1,
    this.currentPage = 1,
  });
  SearchFilterPoductsState copyWith(
      {SearchFilterProductsStatus? status,
      List<MainProduct>? products,
      bool? hasReachedMax,
      String? errorMsg,
      int? currentPage,
      int? totalPages}) {
    return SearchFilterPoductsState(
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

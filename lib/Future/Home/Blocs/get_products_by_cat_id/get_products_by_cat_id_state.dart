part of 'get_products_by_cat_id_bloc.dart';

enum GetProductsByCatIdStatus { loading, success, error }

class GetProductsByCatIdState extends Equatable {
  final GetProductsByCatIdStatus status;
  final List<MainProduct> products;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;
  const GetProductsByCatIdState({
    this.status = GetProductsByCatIdStatus.loading,
    this.hasReachedMax = false,
    this.products = const [],
    this.errorMsg = "",
    this.totalPages = 1,
    this.currentPage = 1,
  });
  GetProductsByCatIdState copyWith(
      {GetProductsByCatIdStatus? status,
      List<MainProduct>? products,
      bool? hasReachedMax,
      String? errorMsg,
      int? currentPage,
      int? totalPages}) {
    return GetProductsByCatIdState(
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

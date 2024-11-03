part of 'get_latest_products_bloc.dart';

enum LatestProductsStatus { loading, success, error }

class GetLatestProductsState extends Equatable {
  final LatestProductsStatus status;
  final List<LatestProducts> latestProducts;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GetLatestProductsState({
    this.status = LatestProductsStatus.loading,
    this.hasReachedMax = false,
    this.latestProducts = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GetLatestProductsState copyWith({
    LatestProductsStatus? status,
    List<LatestProducts>? latestProducts,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GetLatestProductsState(
      status: status ?? this.status,
      latestProducts: latestProducts ?? this.latestProducts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMsg: errorMsg ?? this.errorMsg,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        status,
        latestProducts,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages
      ];
}

part of 'get_offers_bloc.dart';

enum GetOffersStatus { loading, success, error }

class GetOffersState extends Equatable {
  final GetOffersStatus status;
  final List<MainProduct> offersProducts;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GetOffersState({
    this.status = GetOffersStatus.loading,
    this.hasReachedMax = false,
    this.offersProducts = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GetOffersState copyWith({
    GetOffersStatus? status,
    List<MainProduct>? offersProducts,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GetOffersState(
      status: status ?? this.status,
      offersProducts: offersProducts ?? this.offersProducts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMsg: errorMsg ?? this.errorMsg,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        status,
        offersProducts,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages
      ];
}
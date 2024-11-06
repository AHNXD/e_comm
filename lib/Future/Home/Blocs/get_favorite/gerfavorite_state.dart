part of 'gerfavorite_bloc.dart';

enum GetfavoriteStatus { loading, success, error }

class GerfavoriteState extends Equatable {
  final GetfavoriteStatus status;
  final List<FavoriteData> favoriteProducts;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GerfavoriteState({
    this.status = GetfavoriteStatus.loading,
    this.hasReachedMax = false,
    this.favoriteProducts = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GerfavoriteState copyWith({
    GetfavoriteStatus? status,
    List<FavoriteData>? favoriteProducts,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GerfavoriteState(
      status: status ?? this.status,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMsg: errorMsg ?? this.errorMsg,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        status,
        favoriteProducts,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages
      ];
}
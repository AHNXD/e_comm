part of 'get_favorite_bloc.dart';

enum GetFavoriteStatus { loading, success, error }

class GetFavoriteState extends Equatable {
  final GetFavoriteStatus status;
  final List<FavoriteData> favoriteProducts;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GetFavoriteState({
    this.status = GetFavoriteStatus.loading,
    this.hasReachedMax = false,
    this.favoriteProducts = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GetFavoriteState copyWith({
    GetFavoriteStatus? status,
    List<FavoriteData>? favoriteProducts,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GetFavoriteState(
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

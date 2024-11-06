part of 'get_categories_bloc.dart';

enum GetCategoriesStatus { loading, success, error }

class GetCategoriesState extends Equatable {
  final GetCategoriesStatus status;
  final List<CatigoriesData> categories;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GetCategoriesState({
    this.status = GetCategoriesStatus.loading,
    this.hasReachedMax = false,
    this.categories = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GetCategoriesState copyWith({
    GetCategoriesStatus? status,
    List<CatigoriesData>? categories,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GetCategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMsg: errorMsg ?? this.errorMsg,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        status,
        categories,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages
      ];
}
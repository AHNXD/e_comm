part of 'search_filter_poducts_bloc.dart';

sealed class SearchFilterPoductsEvent extends Equatable {
  const SearchFilterPoductsEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsByCatId extends SearchFilterPoductsEvent {
  final String searchText;
  final int categoryId;
  const SearchProductsByCatId(this.categoryId, {required this.searchText});
}

class FilterProductsByCatId extends SearchFilterPoductsEvent {
  final double min;
  final double max;
  final int categoryId;
  const FilterProductsByCatId(this.categoryId,
      {required this.min, required this.max});
}

class ResetSearchFilter extends SearchFilterPoductsEvent {}

class ResetSearchFilterToInit extends SearchFilterPoductsEvent {}

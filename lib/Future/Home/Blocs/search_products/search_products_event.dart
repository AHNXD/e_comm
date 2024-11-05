part of 'search_products_bloc.dart';

sealed class SearchProductsEvent extends Equatable {
  const SearchProductsEvent();

  @override
  List<Object> get props => [];
}

class SearchForProducsEvent extends SearchProductsEvent {
  final String search;

  const SearchForProducsEvent({required this.search});
}

class ResetSearchingToInit extends SearchProductsEvent {}

class ResetSearchText extends SearchProductsEvent {}

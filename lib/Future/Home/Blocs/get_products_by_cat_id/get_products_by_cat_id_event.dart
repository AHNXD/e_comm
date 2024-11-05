part of 'get_products_by_cat_id_bloc.dart';

sealed class GetProductsByCatIdEvent extends Equatable {
  const GetProductsByCatIdEvent();

  @override
  List<Object> get props => [];
}

class GetAllPoductsByCatIdEvent extends GetProductsByCatIdEvent {
  final int categoryID;

  const GetAllPoductsByCatIdEvent({required this.categoryID});
}

class ResetPagination extends GetProductsByCatIdEvent {}

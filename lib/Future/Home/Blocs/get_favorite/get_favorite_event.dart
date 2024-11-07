part of 'get_favorite_bloc.dart';

sealed class GetFavoriteEvent extends Equatable {
  const GetFavoriteEvent();

  @override
  List<Object> get props => [];
}

class GetAllFavoriteEvent extends GetFavoriteEvent {}

class RestPagination extends GetFavoriteEvent {}

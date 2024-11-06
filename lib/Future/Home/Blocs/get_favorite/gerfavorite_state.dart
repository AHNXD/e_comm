part of 'gerfavorite_bloc.dart';

sealed class GerfavoriteState extends Equatable {
  const GerfavoriteState();
  
  @override
  List<Object> get props => [];
}

final class GerfavoriteInitial extends GerfavoriteState {}

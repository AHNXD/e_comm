part of 'get_min_max_cubit.dart';

@immutable
sealed class GetMinMaxState {}

final class GetMinMaxInitial extends GetMinMaxState {}

final class GetMinMaxsuccess extends GetMinMaxState {
  final String minPrice;
  final String maxPrice;

  GetMinMaxsuccess({required this.minPrice, required this.maxPrice});
}

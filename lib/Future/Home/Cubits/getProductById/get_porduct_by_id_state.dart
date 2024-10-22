part of 'get_porduct_by_id_cubit.dart';

@immutable
sealed class GetPorductByIdState {}

final class GetPorductByIdInitial extends GetPorductByIdState {}

final class GetPorductByIdSuccess extends GetPorductByIdState {
  final List<MainProduct> products;

  GetPorductByIdSuccess({required this.products});
}

final class GetAllPorductByIdSuccess extends GetPorductByIdState {
  final List<List<MainProduct>> allProducts;

  GetAllPorductByIdSuccess({required this.allProducts});
}

final class GetPorductByIdLoading extends GetPorductByIdState {}

final class GetPorductByIdError extends GetPorductByIdState {
  final String msg;

  GetPorductByIdError({required this.msg});
}
